# Velebit AI Research Docker

Docker is used for deploying research ready environment with pre-installed environment (CUDA, cudNN, virtualenv...) for data science work.

## Build command example

`docker build -t "<image-name>:<version-number>" .`

## Creating a container for the current user example

`docker run --gpus all --name <container_name> --ipc=host -ti -h <host-name> -v <host-dir>:<docker-dir> -p <host-start>-<host-end>:<docker-start>-<docker-end> -e NAME=$USER -e ID=$UID -e GID=<user_group_id> -e CODE_PATH=</some_path/some_code_dir> -e DS_ID=<datascience_id> <image-name>:<version-number>`

**WARNING**
This command requires Docker version >=19.03. As of 19.03, Docker supports GPU containers thus making the `nvidia-docker` deprecated.
You still need to install the `nvidia-container-toolkit` following the instructions [here](https://github.com/NVIDIA/nvidia-docker).


## Other notes

* All shell configuration commands are stored in the `.shell_cfg.bash` located in the user home folder. `.bashrc` sources this file.
* `DS_ID` should correspond to some common user group id for shared access (optional)
* `CODE_PATH` is the base path for code repos to be added to PYTHONPATH (optional)
* check `setuser.sh` for more details
