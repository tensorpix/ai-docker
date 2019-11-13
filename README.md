# Velebit AI Research Docker

Docker is used for deploying research ready environment with pre-installed
libraries such as Tensorflow, PyTorch, scikit, numpy, etc.
The base `Dockerfile` is located in the root directory and it does not install extra pip packages. `Dockerfile` with pre-installed pip packages is in the `extras-dockerfile` directory. This dockerfile uses the base dockerfile as the starting point.

## Build command example
`docker build -t research:<version-number>`

## Creating a container for the current user example
`nvidia-docker run --name container_name --ipc=host -ti -h research_docker -v /data:/data -v /shared:/shared -p 10000-10100:10000-10100 -e NAME=$USER -e ID=$UID -e GID=user_group_id -e CODE_PATH=/some_path/some_code_dir -e DS_ID=<datascience_id> research:1.1.0`


## Other notes
* All shell configuration commands are stored in the `.shell_cfg.bash` located in the user home folder. `.bashrc` sources this file.
* `nvidia-docker` and nvidia driver are dependencies that must be installed on the host machine
* `DS_ID` should correspond to some common user group id for shared access (optional)
* `CODE_PATH` is the base path for code repos to be added to PYTHONPATH (optional)
* check `setuser.sh` for more details
