#!/usr/bin/env bash

# Build a virtual machine containing GameShell and all its dependencies, as an
# OVA file that VirtualBox and VMware can import.
#
# The VM is not installed from scratch: we start from the official Debian
# "nocloud" cloud image and customize it offline with libguestfs, which is
# considerably faster and does not require booting anything.
#
# Required tools: curl, qemu-img, virt-resize / virt-customize
# (libguestfs-tools) and VBoxManage (virtualbox), which is only used to
# package the disk -- no virtual machine is ever started.

set -euo pipefail

ARCHIVE="gameshell.sh"
OUTPUT="gameshell.ova"
RELEASE="bookworm"
DISK_SIZE="8G"
VM_NAME="GameShell"
VM_USER="gsh-user"
VM_PASSWORD="gameshell"
MEMORY=2048
CPUS=2

usage() {
  cat <<EOF
$(basename "$0") [OPTIONS]

  -h              this message
  -a ARCHIVE      GameShell self-extracting archive (default: $ARCHIVE)
  -o OUTPUT       name of the generated OVA file (default: $OUTPUT)
  -r RELEASE      Debian release to base the VM on (default: $RELEASE)
  -s SIZE         size of the virtual disk (default: $DISK_SIZE)
  -u USER         login of the VM's user (default: $VM_USER)
  -p PASSWORD     password of the VM's user (default: $VM_PASSWORD)
EOF
}

while getopts "ha:o:r:s:u:p:" opt
do
  case "$opt" in
    h) usage; exit 0 ;;
    a) ARCHIVE="$OPTARG" ;;
    o) OUTPUT="$OPTARG" ;;
    r) RELEASE="$OPTARG" ;;
    s) DISK_SIZE="$OPTARG" ;;
    u) VM_USER="$OPTARG" ;;
    p) VM_PASSWORD="$OPTARG" ;;
    *) usage >&2; exit 1 ;;
  esac
done

case "$RELEASE" in
  bullseye) VERSION=11 ;;
  bookworm) VERSION=12 ;;
  trixie)   VERSION=13 ;;
  *) echo "Error: unknown Debian release '$RELEASE'" >&2; exit 1 ;;
esac

for cmd in curl qemu-img virt-resize virt-customize VBoxManage
do
  if ! command -v "$cmd" >/dev/null
  then
    echo "Error: '$cmd' is required to build the VM image" >&2
    exit 1
  fi
done

if ! [ -f "$ARCHIVE" ]
then
  echo "Error: no such file '$ARCHIVE', generate it with utils/archive.sh" >&2
  exit 1
fi
ARCHIVE="$(cd "$(dirname "$ARCHIVE")" && pwd)/$(basename "$ARCHIVE")"
OUTPUT="$(cd "$(dirname "$OUTPUT")" && pwd)/$(basename "$OUTPUT")"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

###
# 1/ fetch the official Debian cloud image, and check it
BASE_URL="https://cloud.debian.org/images/cloud/$RELEASE/latest"
IMAGE="debian-$VERSION-nocloud-amd64.qcow2"

echo "### downloading $IMAGE"
curl -fL --retry 3 -o "$WORKDIR/$IMAGE" "$BASE_URL/$IMAGE"
curl -fL --retry 3 -o "$WORKDIR/SHA512SUMS" "$BASE_URL/SHA512SUMS"
( cd "$WORKDIR" && grep " $IMAGE\$" SHA512SUMS | sha512sum --check - )

###
# 2/ give the VM a disk students can actually work in
echo "### resizing the disk to $DISK_SIZE"
qemu-img create -f qcow2 "$WORKDIR/disk.qcow2" "$DISK_SIZE" >/dev/null
virt-resize --expand /dev/sda1 "$WORKDIR/$IMAGE" "$WORKDIR/disk.qcow2"

###
# 3/ the files we need to add to the guest
mkdir -p "$WORKDIR/files"

# the cloud image only talks to the serial console, which stays invisible in
# VirtualBox: send the kernel messages and the login prompt to the screen
cat > "$WORKDIR/files/autologin.conf" <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $VM_USER --noclear %I \$TERM
EOF

cat > "$WORKDIR/files/profile" <<EOF
# shown when $VM_USER logs in
if [ -f "\$HOME/$(basename "$ARCHIVE")" ]
then
  echo
  echo "Welcome to GameShell!"
  echo
  echo "To start playing, run:"
  echo
  echo "    ./$(basename "$ARCHIVE")"
  echo
fi
EOF

###
# 4/ install GameShell and its dependencies
# (the dependencies are those listed in doc/deps.md, plus a C compiler, which
# the "processes" missions use to build their background process)
DEPS="locales,gettext,man-db,procps,psmisc,nano,tree,bsdmainutils,bsdextrautils"
DEPS="$DEPS,x11-apps,wget,gcc,libc6-dev,zsh"

echo "### installing GameShell and its dependencies"
virt-customize -a "$WORKDIR/disk.qcow2" \
  --hostname "gameshell" \
  --install "$DEPS" \
  --run-command "sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen" \
  --run-command "locale-gen" \
  --run-command "update-locale LANG=en_US.UTF-8" \
  --run-command "useradd --create-home --shell /bin/bash '$VM_USER'" \
  --password "$VM_USER:password:$VM_PASSWORD" \
  --root-password "password:$VM_PASSWORD" \
  --copy-in "$ARCHIVE:/home/$VM_USER" \
  --run-command "chmod 755 '/home/$VM_USER/$(basename "$ARCHIVE")'" \
  --upload "$WORKDIR/files/profile:/home/$VM_USER/.profile" \
  --run-command "chown -R '$VM_USER:$VM_USER' '/home/$VM_USER'" \
  --mkdir /etc/systemd/system/getty@tty1.service.d \
  --upload "$WORKDIR/files/autologin.conf:/etc/systemd/system/getty@tty1.service.d/autologin.conf" \
  --run-command "sed -i -e 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"\"/' -e 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet\"/' -e '/^GRUB_TERMINAL/d' -e '/^GRUB_SERIAL_COMMAND/d' /etc/default/grub" \
  --run-command "update-grub" \
  --truncate /etc/machine-id

###
# 5/ package the disk as an OVA
# VBoxManage is only used to write the OVF descriptor and tar it up: the VM is
# created, exported and thrown away without ever being started, so this works
# on a machine that cannot run VirtualBox at all.
echo "### packaging $OUTPUT"
qemu-img convert -f qcow2 -O vdi "$WORKDIR/disk.qcow2" "$WORKDIR/$VM_NAME.vdi"

export VBOX_USER_HOME="$WORKDIR/vbox"
mkdir -p "$VBOX_USER_HOME"

VBoxManage createvm --name "$VM_NAME" --ostype "Debian_64" \
  --basefolder "$WORKDIR/vbox-machines" --register
VBoxManage modifyvm "$VM_NAME" \
  --memory "$MEMORY" --cpus "$CPUS" --vram 32 \
  --graphicscontroller vmsvga --nic1 nat
VBoxManage storagectl "$VM_NAME" --name "SATA" --add sata \
  --controller IntelAhci --portcount 1
VBoxManage storageattach "$VM_NAME" --storagectl "SATA" \
  --port 0 --device 0 --type hdd --medium "$WORKDIR/$VM_NAME.vdi"

rm -f "$OUTPUT"
VBoxManage export "$VM_NAME" --output "$OUTPUT" \
  --vsys 0 \
  --product "GameShell" \
  --producturl "https://github.com/phyver/GameShell" \
  --vmname "$VM_NAME"

echo
echo "### $OUTPUT is ready"
echo "### log in as '$VM_USER' (password '$VM_PASSWORD')"
