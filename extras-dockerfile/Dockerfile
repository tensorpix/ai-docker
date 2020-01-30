FROM registry.gitlab.com/velebit/research/docker/base:1.2.1

COPY python_packages.txt /etc/

# Python packages
RUN python3 -m pip install -r /etc/python_packages.txt
