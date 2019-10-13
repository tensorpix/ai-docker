# Styria.ai Research Docker

Docker is used for deploying research ready environment with pre-installed
libraries such as Tensorflow, PyTorch, scikit, numpy, etc.

## Build command example
`docker build -t research:2.3.0 .`

## Creating a container for the current user
`nvidia-docker run --name container_name --ipc=host -ti -h tf_docker -v /data:/data -v /shared:/shared -p 10000-10100:10000-10100 -e NAME=$USER -e ID=$UID -e DS_CODE_PATH=/some_path/some_code_dir research:2.3.0`

## Optional: switching to datascience user inside container
`sudo -E su datascience`

## Host notes

* `nvidia-docker` and the nvidia driver are dependencies and must be installed on host machine
* main user is the `datascience` user, other users must be in the `datascience` group
