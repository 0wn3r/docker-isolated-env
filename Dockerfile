FROM ubuntu:20.04

LABEL maintainer="Artem Kostin <artem.kostin@globallogic.com>"
LABEL description="Android Build System Isolated Environment"
LABEL version="1.0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
    openjdk-8-jdk \
    ccache \
    automake \
    lzop \
    bison \
    gperf \
    build-essential \
    zip \
    curl \
    zlib1g-dev \
    g++-multilib \
    python3-networkx \
    libxml2-utils \
    bzip2 \
    libbz2-dev \
    libbz2-1.0 \
    libghc-bzlib-dev \
    squashfs-tools \
    pngcrush \
    schedtool \
    dpkg-dev \
    liblz4-tool \
    make \
    optipng \
    maven \
    libssl-dev \
    libncurses5 \
    git \
    gnupg \
    flex \
    gcc-multilib \
    libc6-dev-i386 \
    lib32ncurses5-dev \
    x11proto-core-dev \
    libx11-dev \
    lib32z1-dev \
    libgl1-mesa-dev \
    xsltproc \
    unzip \
    fontconfig \
    libxml-simple-perl \
    python2 \
    python-is-python2 \
    bc \
    libncurses-dev \
    gawk \
    openssl \
    dkms \
    libelf-dev \
    libudev-dev \
    libpci-dev \
    libiberty-dev \
    autoconf \
    bsdmainutils   \
    libncurses5-dev \
    libsdl1.2-dev \
    libwxgtk3.0-gtk3-dev \
    pngcrush \
    graphviz \
    mc \
    htop \
    vim \
    screen \
    rsync \
    nload \
    uuid-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
RUN python2 get-pip.py

RUN pip install pycryptodome

# Fix openjdk-8-292+ security improvement
RUN sed -i -e "s@^jdk.tls.disabledAlgorithms=.*\$@jdk.tls.disabledAlgorithms=SSLv3, RC4, DES, MD5withRSA, \\\@" /etc/java-8-openjdk/security/java.security

# Add build user account, values are set to default below
ENV RUN_USER ubuntu
ENV RUN_UID 1000

ENV USER_HOME /home/ubuntu
RUN mkdir -pv ${USER_HOME}

RUN adduser \
    --gecos 'Build User' \
    --shell '/usr/bin/bash' \
    --uid ${RUN_UID} \
    --disabled-login \
    --disabled-password ${RUN_USER}

COPY ./ubuntu/.bashrc ${USER_HOME}
COPY ./ubuntu/.bash_custom_settings ${USER_HOME}

RUN mkdir -p ${USER_HOME}/.bin
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ${USER_HOME}/.bin/repo
RUN chmod a+rx ${USER_HOME}/.bin/repo

RUN chown -R ${RUN_USER}:${RUN_USER} ${USER_HOME}
RUN chmod -R 775 ${USER_HOME}

USER ${RUN_USER}
ENV USER ${RUN_USER}
WORKDIR ${USER_HOME}

CMD ["bash"]
