# Styria.AI research docker image
# Python 3.7
# Ubuntu 18.04, CUDA 10.0, Tensorflow, PyTorch

# Note: system Python is still 3.5, and running scripts requires explicit
# python3.7 some_script.py

# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu.Dockerfile

ARG UBUNTU_VERSION=18.04

ARG ARCH=
ARG CUDA=10.0
FROM nvidia/cuda${ARCH:+-$ARCH}:${CUDA}-base-ubuntu${UBUNTU_VERSION} as base
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG ARCH
ARG CUDA
ARG CUDNN=7.4.1.5-1
ARG CUDNN_MAJOR_VERSION=7
ARG LIB_DIR_PREFIX=x86_64
ARG TRT_VERSION=1804

# Needed for string substitution
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-${CUDA/./-} \
        cuda-cublas-dev-${CUDA/./-} \
        cuda-cudart-dev-${CUDA/./-} \
        cuda-cufft-dev-${CUDA/./-} \
        cuda-curand-dev-${CUDA/./-} \
        cuda-cusolver-dev-${CUDA/./-} \
        cuda-cusparse-dev-${CUDA/./-} \
        libcudnn7=${CUDNN}+cuda${CUDA} \
        libcudnn7-dev=${CUDNN}+cuda${CUDA} \
        libcurl3-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev \
        wget \
        git \
        && \
    find /usr/local/cuda-${CUDA}/lib64/ -type f -name 'lib*_static.a' -not -name 'libcudart_static.a' -delete && \
    rm /usr/lib/${LIB_DIR_PREFIX}-linux-gnu/libcudnn_static_v7.a

RUN [[ "${ARCH}" = "ppc64le" ]] || { apt-get update && \
        apt-get install nvinfer-runtime-trt-repo-ubuntu${TRT_VERSION}-5.0.2-ga-cuda${CUDA} \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
            libnvinfer5=5.0.2-1+cuda${CUDA} \
            libnvinfer-dev=5.0.2-1+cuda${CUDA} \
        && apt-get clean \
&& rm -rf /var/lib/apt/lists/*; }

# For CUDA profiling, TensorFlow requires CUPTI.
# make sure to keep cuda paths when switching users
RUN echo "PATH="/usr/local/nvidia/bin:/usr/local/cuda/bin:$PATH"" >> /etc/environment && \
    echo "LD_LIBRARY_PATH="/usr/local/cuda/extras/CUPTI/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64"" >> /etc/environment

# some extras
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
        libncursesw5-dev \
        libopenblas-dev \
        libpq-dev \
        libreadline-gplv2-dev \
        libssl-dev \
        libsqlite3-dev \
        locales \
        nano \
        htop \
        iotop \
        gfortran \
        g++ \
        imagemagick \
        openjdk-8-jdk \
        python-profiler \
        ssh \
        sudo \
        swig \
        tk-dev \
        tmux \
        tzdata \
        vim \
        zsh \
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

# install Python 3.7 and pip
# https://docs.python-guide.org/starting/install3/linux/

RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update && \
    apt-get install -y python3.7 python3.7-dev
RUN curl https://bootstrap.pypa.io/get-pip.py -o /usr/src/get-pip.py && \
    python3.7 /usr/src/get-pip.py

# Python packages
RUN python3.7 -m pip --no-cache-dir install --upgrade \
    beautifulsoup4 bottleneck colormath commentjson cython \
    decorator flake8 flask flask-paginate ftfy future gensim h5py imutils ipython \
    iterative-stratification jedi jupyter keras_applications keras_preprocessing lxml \
    mahotas matplotlib mock networkx nltk nose \
    numexpr numpy pandas pep8 psycopg2 pyflakes pylint \
    python-dateutil pyyaml qtconsole rope_py3k scikit-image \
    scikit-learn scipy sip sphinx SQLAlchemy tables  \
    tensorboard torch torchvision tensorboardX \
    opencv-contrib-python-headless pretrainedmodels tensorflow-gpu voluptuous

# use pillow-simd with AVX2 support
RUN pip3 uninstall -y pillow && CC="cc -mavx2" pip3 install -U --force-reinstall pillow-simd

# create user at runtime
COPY install_oh-my-zsh.sh /usr/bin/
COPY setuser.sh /bin/
ENTRYPOINT /bin/setuser.sh

#################################### NOTES ######################################################
### building example:
# docker build -t research:2.3.0 .

### create the container for the current user:
# nvidia-docker run --name my_tf_container --ipc=host -ti -h tf_docker -v /data:/data -v /shared:/shared -p 10000-10100:10000-10100 -e NAME=$USER -e ID=$UID -e DS_CODE_PATH=/some_path/some_code_dir research:2.3.0

### (optional) switching to datascience user inside container:
# sudo -E su datascience

### host notes:
# nvidia-docker and nvidia driver installed on host
# main user datascience, other users in group datascience
