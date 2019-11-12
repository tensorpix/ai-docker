FROM 10.1-cudnn7-runtime-ubuntu18.04

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
        libreadline-gplv2-dev \
        libreadline-dev \
        libssl-dev \
        libsqlite3-dev \
        libffi-dev \
        liblzma-dev \
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

# Install pip, pyenv and pipenv
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3 /tmp/get-pip.py
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
RUN sudo pip install pipenv

# create user at runtime
COPY setuser.sh /bin/
ENTRYPOINT /bin/setuser.sh
