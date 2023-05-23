FROM nvcr.io/nvidia/pytorch:23.04-py3


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sudo \
    libgtk2.0-dev \
    pkg-config \
    build-essential \
    cmake \
    git \
    pkg-config \ 
    libgtk-3-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    gfortran \
    openexr \
    libatlas-base-dev \
    python3-numpy \
    libtbb2 \
    libtbb-dev \
    libdc1394-22-dev \
    libopenexr-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer1.0-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# create user at runtime
COPY setuser.sh /bin/

RUN pip install --upgrade pip && \
    pip install configparser mediapipe

#mim and mmcv +mmengine different layers bcs my sanity is fragile
RUN sudo pip3 install openmim

RUN sudo mim install 'mmcv>=2.0.0' && \
    sudo mim install 'mmengine' 

#rather build mmagic from source this shit brokenzo
#RUN sudo mim install 'mmagic'

RUN git clone https://github.com/open-mmlab/mmagic /mmagic
WORKDIR /mmagic 
RUN pip install -r requirements.txt && \
    pip install --no-cache-dir -e .

#change entire home folder owner to groupid 1004 - the aimages grp on the train2 workstation - kinda magic number like 
#but there's no need to run this every time with setuser.sh
RUN sudo chown -R :1004 /home/ && \
    echo './bin/setuser.sh' >> ~/.bashrc
WORKDIR /
ENTRYPOINT /bin/setuser.sh
