FROM debian:stable

###
# install dependencies
RUN apt update
RUN apt install --no-install-recommends --assume-yes \
    locales \
    gettext \
    man-db \
    psmisc \
    procps \
    nano \
    tree \
    ncal \
    x11-apps \
    zsh \
    git \
    python3
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

###
# install locales and set default
RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
RUN sed -i 's/^# *\(fr_FR.UTF-8\)/\1/' /etc/locale.gen
RUN locale-gen
RUN update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

###
# set user and group
ARG user=gsh-user
ARG group=gsh-user
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -s /bin/sh -m ${user} # <--- the '-m' create a user home directory

###
# switch to user
USER ${uid}:${gid}
WORKDIR /home/${user}


### by default, use the latest version published on github
###
### to build the image from a local, customized version instead, generate a
### "gameshell.sh" file with GSH_ROOT/utils/archive.sh and give its path,
### relative to the build context:
###   ./utils/archive.sh && docker build --build-arg GSH_ARCHIVE=gameshell.sh -t gsh .
ARG GSH_ARCHIVE=https://github.com/phyver/GameShell/releases/download/latest/gameshell.sh
ADD --chown=gsh-user:gsh-user ${GSH_ARCHIVE} gameshell.sh

ENTRYPOINT ["bash", "./gameshell.sh"]
