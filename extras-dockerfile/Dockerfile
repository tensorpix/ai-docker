FROM registry.gitlab.com/velebit/research/docker/base:1.2.0

COPY python_packages.txt /etc/

# Python packages
RUN python3 -m pip install -r /etc/python_packages.txt

# use pillow-simd with AVX2 support
RUN pip3 uninstall -y pillow && CC="cc -mavx2" pip3 install -U --force-reinstall Pillow-SIMD==6.0.0.post0
