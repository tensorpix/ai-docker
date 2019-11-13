FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        byobu \
        checkinstall \
        cmake \
        curl \
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
        liblzma-dev \
	libcairo2-dev \
        llvm \
        locales \
        nano \
        htop \
        iotop \
        gfortran \
        g++ \
        git \
        imagemagick \
        openjdk-8-jdk \
        python-profiler \
        python-openssl \
        ssh \
        sudo \
        swig \
        tk-dev \
        tmux \
        tzdata \
        xz-utils \
        vim \
        zsh \
        wget \
        zlib1g-dev \
        rsync \
        unzip \
        python3-distutils \
	libcairo2-dev \
        python3-dev \
        libgirepository1.0-dev \
        libjpeg-dev \
        python-apt \
        zip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# set locale
RUN sudo locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# timezone
RUN echo Europe/Zagreb > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# Install pip and pipenv
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3 /tmp/get-pip.py && \ 
    sudo pip install pipenv

# create user at runtime
COPY setuser.sh /bin/
ENTRYPOINT /bin/setuser.sh

