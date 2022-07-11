FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    byobu \
    checkinstall \
    cmake \
    curl \
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
    python3-dev \
    python-apt \
    python3-distutils \
    rsync \
    ssh \
    sudo \
    swig \
    tk-dev \
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

# Install TensorRT
WORKDIR /usr/local/lib/deps
# Must match the base image CUDA and cudnn versions. TensorRT 8.2.5.1 is also compatible with CUDA 11.3.1
RUN curl -o tensorrt.tar.gz https://aimages-videos.fra1.digitaloceanspaces.com/inference-server-dependencies/TensorRT-8.2.5.1.Linux.x86_64-gnu.cuda-11.4.cudnn8.2.tar.gz
RUN curl -o libtorch.tar.gz https://aimages-videos.fra1.digitaloceanspaces.com/inference-server-dependencies/libtorchtrt-v1.1.0-cudnn8.2-tensorrt8.2-cuda11.3-libtorch1.11.0.tar.gz

RUN mkdir tensorrt && \
    tar -xvzf tensorrt.tar.gz --directory tensorrt --strip-components=1 && \
    tar -xvzf libtorch.tar.gz
RUN rm *.tar.gz
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/deps/torch_tensorrt/lib:/usr/local/lib/deps/tensorrt/lib

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
    sudo pip install virtualenvwrapper flake8

COPY recipes /recipes

# create user at runtime
COPY setuser.sh /bin/
ENTRYPOINT /bin/setuser.sh
