FROM nvidia/cuda:12.0.0-cudnn8-devel-ubuntu20.04

#i'm not sure whether this many packages are needed but i know you need some of these for opencv to work - torchvision blabla so i 
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    byobu \
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
    python-profiler \
    python-openssl \
    python3-dev \
    python-apt \
    python3-distutils \
    iotop \
    gfortran \
    g++ \
    git \
    rsync \
    ssh \
    swig \
    tk-dev \
    tmux \
    tzdata \
    unzip \
    vim \
    xz-utils \
    wget \
    zip \
    zsh \
    zlib1g-dev \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3 /tmp/get-pip.py && \
    pip install --upgrade pip && \
    sudo pip install virtualenvwrapper flake8 \
    pip install jupyterlab
    #INSTALLATION OF PYTHON LIBRARIES SHOULD BE DONE IN A VIRUTAL ENVIRONMENT!!!!
    #pip install torch torchvision jupyter jupyterlab pytorch-ignite

# timezone i guess
RUN echo Europe/Zagreb > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata


# create user at runtime
COPY setuser.sh /bin/

#change entire home folder owner to groupid 1004 - the aimages grp on the train2 workstation - kinda magic number like 
#but there's no need to run this every time with setuser.sh
RUN sudo chown -R :1004 /home/ && \
    echo './bin/setuser.sh' >> ~/.bashrc

ENTRYPOINT /bin/setuser.sh
