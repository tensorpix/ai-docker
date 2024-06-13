FROM nvidia/cuda:12.0.0-cudnn8-devel-ubuntu22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    checkinstall \
    cmake \
    ffmpeg \
    less \
    libbz2-dev \
    libcupti-dev \
    libc6-dev \
    libgdbm-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libopenblas-dev \
    libpq-dev \
    libreadline-dev \
    libssl-dev \
    libsqlite3-dev \
    libffi-dev \
    libcairo2-dev \
    libgirepository1.0-dev \
    libjpeg-dev \
    liblzma-dev \
    llvm \
    sudo \
    locales \
    nano \
    htop \
    python3-dev \
    python3-distutils \
    python3-venv \
    python3-pip \
    gfortran \
    g++ \
    git \
    tmux \
    tzdata \
    unzip \
    vim \
    xz-utils \
    wget \
    zip \
    zlib1g-dev \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV TZ="Europe/Zagreb"
ENV TERM=xterm-256color
# create user at runtime
COPY setuser.sh /bin/

#change entire home folder owner to groupid 1004 - the aimages grp on the train2 workstation - kinda magic number like 
#but there's no need to run this every time with setuser.sh
RUN sudo chown -R :1004 /home/

ENTRYPOINT /bin/setuser.sh
