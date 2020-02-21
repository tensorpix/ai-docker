# install NVIDIA apex
function check_deps() {
    pip3 show numpy && \
    pip3 show torch
}

function install_apex() {
    RANDOM_FOLDER_NAME=$(mktemp --dry-run) && \
    git clone https://github.com/NVIDIA/apex.git $RANDOM_FOLDER_NAME && \
    cd $RANDOM_FOLDER_NAME && \
    pip3 install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
}

function cleanup() {
    rm -rf $RANDOM_FOLDER_NAME
}

check_deps && install_apex
cleanup
