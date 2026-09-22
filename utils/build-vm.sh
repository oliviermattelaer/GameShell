#!/usr/bin/env bash

# Build a virtual machine containing GameShell and all its dependencies, as an
# OVA file that VirtualBox and VMware can import.
#
# The VM is not installed from scratch: we start from the official Debian
# cloud image, grow its disk, and install what we need in a chroot.  That is
# much faster than running an installer, and it uses the build machine's own
# network, so nothing has to be booted.
#
# Required tools: curl, qemu-img, growpart (cloud-guest-utils), resize2fs,
# sudo, and VBoxManage (virtualbox), which is only used to package the disk --
# no virtual machine is ever started.

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

# the dependencies listed in doc/deps.md, plus git and python3, which the
# missions of this branch are about / are built with
DEPS="locales gettext man-db procps psmisc nano tree ncal x11-apps"
DEPS="$DEPS wget zsh git python3"

for cmd in curl qemu-img growpart sudo VBoxManage
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
ARCHIVE_NAME="$(basename "$ARCHIVE")"

WORKDIR="$(mktemp -d)"
MOUNT="$WORKDIR/mnt"
LOOP=""

cleanup() {
  set +e
  if [ -n "$MOUNT" ] && mountpoint -q "$MOUNT"
  then
    sudo umount --recursive "$MOUNT"
  fi
  if [ -n "$LOOP" ]
  then
    sudo losetup --detach "$LOOP"
  fi
  rm -rf "$WORKDIR"
}
trap cleanup EXIT

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
echo "### growing the disk to $DISK_SIZE"
qemu-img convert -f qcow2 -O raw "$WORKDIR/$IMAGE" "$WORKDIR/disk.raw"
qemu-img resize -f raw "$WORKDIR/disk.raw" "$DISK_SIZE"

LOOP="$(sudo losetup --find --partscan --show "$WORKDIR/disk.raw")"
echo "### $WORKDIR/disk.raw is $LOOP"
# the root partition of a Debian cloud image is the last one on the disk,
# whatever its number, so it can simply be grown in place
sudo growpart "$LOOP" 1
sudo partx --update "$LOOP"
sudo e2fsck -fy "${LOOP}p1" || true
sudo resize2fs "${LOOP}p1"

###
# 3/ install GameShell and its dependencies in the image
mkdir -p "$MOUNT"
sudo mount "${LOOP}p1" "$MOUNT"
sudo mount --bind /dev "$MOUNT/dev"
sudo mount --bind /dev/pts "$MOUNT/dev/pts"
sudo mount -t proc proc "$MOUNT/proc"
sudo mount -t sysfs sys "$MOUNT/sys"

# let the chroot resolve names, and keep whatever the image had
sudo mv "$MOUNT/etc/resolv.conf" "$MOUNT/etc/resolv.conf.gsh" 2>/dev/null || true
printf 'nameserver 1.1.1.1\nnameserver 8.8.8.8\n' |
  sudo tee "$MOUNT/etc/resolv.conf" >/dev/null

# no daemon should be started while we install packages in a chroot
printf '#!/bin/sh\nexit 101\n' | sudo tee "$MOUNT/usr/sbin/policy-rc.d" >/dev/null
sudo chmod 755 "$MOUNT/usr/sbin/policy-rc.d"

echo "### installing the dependencies"
sudo chroot "$MOUNT" /bin/bash -c "
  set -e
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install --no-install-recommends --assume-yes $DEPS
  apt-get clean
"

echo "### configuring the system"
sudo chroot "$MOUNT" /bin/bash -c "
  set -e
  sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
  locale-gen
  update-locale LANG=en_US.UTF-8
  useradd --create-home --shell /bin/bash '$VM_USER'
  echo '$VM_USER:$VM_PASSWORD' | chpasswd
  echo 'root:$VM_PASSWORD' | chpasswd
"
echo "gameshell" | sudo tee "$MOUNT/etc/hostname" >/dev/null

# The cloud image only talks to the serial console, which stays invisible in
# VirtualBox.  Show the boot menu and the kernel messages on the screen, but
# keep the serial console as well: it costs nothing in a hypervisor, and it is
# what the smoke test below reads.
sudo sed -i \
  -e 's/console=ttyS0[^ "]*/console=tty0 console=ttyS0,115200n8/g' \
  -e '/^serial /d' \
  -e 's/^terminal_input .*/terminal_input console serial/' \
  -e 's/^terminal_output .*/terminal_output console serial/' \
  "$MOUNT/boot/grub/grub.cfg"
sudo sed -i \
  -e 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=""/' \
  -e 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty0 console=ttyS0,115200n8"/' \
  -e '/^GRUB_TERMINAL/d' \
  -e '/^GRUB_SERIAL_COMMAND/d' \
  "$MOUNT/etc/default/grub"

# log the player in automatically, this is a game
sudo mkdir -p "$MOUNT/etc/systemd/system/getty@tty1.service.d"
sudo tee "$MOUNT/etc/systemd/system/getty@tty1.service.d/autologin.conf" >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $VM_USER --noclear %I \$TERM
EOF

# the game itself
sudo cp "$ARCHIVE" "$MOUNT/home/$VM_USER/$ARCHIVE_NAME"
sudo chmod 755 "$MOUNT/home/$VM_USER/$ARCHIVE_NAME"
sudo chroot "$MOUNT" chown -R "$VM_USER:$VM_USER" "/home/$VM_USER"

sudo tee "$MOUNT/etc/profile.d/gameshell.sh" >/dev/null <<EOF
# shown on login
if [ -f "\$HOME/$ARCHIVE_NAME" ]
then
  echo
  echo "Welcome to GameShell!"
  echo
  echo "To start playing, run:"
  echo
  echo "    ./$ARCHIVE_NAME"
  echo
fi
EOF

# put the image back in a pristine state
sudo rm -f "$MOUNT/usr/sbin/policy-rc.d"
sudo rm -f "$MOUNT/etc/resolv.conf"
sudo mv "$MOUNT/etc/resolv.conf.gsh" "$MOUNT/etc/resolv.conf" 2>/dev/null || true
sudo truncate -s 0 "$MOUNT/etc/machine-id"
sudo rm -f "$MOUNT/var/lib/systemd/random-seed"
sudo rm -rf "$MOUNT/var/lib/apt/lists/"*

sudo umount --recursive "$MOUNT"
sudo losetup --detach "$LOOP"
LOOP=""

###
# 4/ check that what we built actually boots
# Without this, a broken bootloader or a mistake in the console settings would
# only be found by whoever imports the OVA.
if [ -z "${GSH_VM_SKIP_BOOT_TEST:-}" ] && command -v qemu-system-x86_64 >/dev/null
then
  echo "### checking that the image boots"
  : > "$WORKDIR/console.log"
  qemu-system-x86_64 \
    -machine "accel=kvm:tcg" -m 1024 -smp 2 -no-reboot \
    -drive "file=$WORKDIR/disk.raw,format=raw" \
    -display none -serial "file:$WORKDIR/console.log" &
  qemu_pid=$!

  booted=""
  for _ in $(seq 60)
  do
    if grep -q "gameshell login:" "$WORKDIR/console.log" 2>/dev/null
    then
      booted=yes
      break
    fi
    if ! kill -0 "$qemu_pid" 2>/dev/null
    then
      break
    fi
    sleep 5
  done
  kill "$qemu_pid" 2>/dev/null || true
  wait "$qemu_pid" 2>/dev/null || true

  if [ -z "$booted" ]
  then
    echo "Error: the image did not reach a login prompt, console was:" >&2
    tail -n 60 "$WORKDIR/console.log" >&2
    exit 1
  fi
  echo "### the image boots and reaches a login prompt"
fi

###
# 5/ package the disk as an OVA
# VBoxManage is only used to write the OVF descriptor and tar it up: the VM is
# created, exported and thrown away without ever being started, so this works
# on a machine that cannot run VirtualBox at all.
echo "### packaging $OUTPUT"
qemu-img convert -f raw -O vdi "$WORKDIR/disk.raw" "$WORKDIR/$VM_NAME.vdi"

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
