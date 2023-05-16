# Aimages research docker v0.1

## ssh command
`ssh -p 141 -L 10123:localhost:10123 user@IP`

* this port (10123) is forwarded for jupyter lab

## Building the docker image 
(it should already be there when you write `docker image ls`)

In case it is not, position yourself in the folder with the Dockerfile and setuser.sh and run:
`docker build -t ubuntu20_cuda12.0_cudnn8 .`

## Docker run command
this is my personal goto docker run command, you can change it to your liking. I mount 3 different folder from the host machine: code, data, experiments and set the environment variables for the user and group id. Also i forward the port 10123 for jupyter lab.

`docker run -it -p 10123:10123 --runtime=nvidia --name=$(whoami)-torchtest --gpus all --ipc=host --ulimit memlock=-1 -v ~/data:/home/jeronim/data -v ~/experiments:/home/jeronim/experiments -v ~/code:/home/jeronim/code -e NAME=$USER -e ID=$UID -e GID=1001 -e DS_ID=1004 ubuntu20_cuda12.0_cudnn8`

## Opening a new shell
this is for opening mulitple shells in the same container and not messing up the permissions. rwx permissions should work as intended here with the user:group -> user is your user and group is aimages(1004). userid and groupid are set in the docker run command above. as ID and DS_ID respectively.

`docker exec -it $(whoami)-torchtest bash`

## Jupyter lab command
* don't ever ever run a jupyter lab without a password

`jupyter-lab --ip 0.0.0.0 --port 10123 --allow-root`
browse your jupyter on local machine at: localhost:10123

#TODO: venv stuff - i think works