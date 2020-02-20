# install NVIDIA apex
set -e

cd /tmp
git clone https://github.com/NVIDIA/apex.git
cd apex
pip3 install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
rm -rf /tmp/apex
