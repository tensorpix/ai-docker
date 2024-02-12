# TensorPix Research Docker

## ssh command

`ssh -p 141 -L 10123:localhost:10123 -E sshdump user@IP`

- port 141
- this port (10123) is forwarded for jupyter lab
- dumps all error msgs in to sshdump (error3 connection refused was getting spammed in the terminal bcs of the port forwarding idk idc)

## Building the docker image

In case it is not, position yourself in the folder with the Dockerfile and setuser.sh and run:
`docker build -t <image-name>:<tag> .`

## Docker run command

this is my personal goto docker run command, you can change it to your liking. I mount 3 different folder from the host machine: code, data, experiments and set the environment variables for the user and group id. Also i forward the port 10123 for jupyter lab.

`docker run -it -p 6006:6006 -p 10123:10123 --name=$(whoami)-research --gpus all --ipc=host --ulimit memlock=-1 -v /data:/data -v ~/experiments:/home/jeronim/experiments -v ~/code:/home/jeronim/code -e NAME=$USER -e ID=$UID -e GID=1001 -e DS_ID=1004 <image-name>:<tag>`

## Opening a new shell

this is for opening mulitple shells in the same container and not messing up the permissions. rwx permissions should work as intended here with the user:group -> user is your user and group is aimages(1004). userid and groupid are set in the docker run command above. as ID and DS_ID respectively.

`docker exec -it $(whoami)-research bash`

## Jupyter lab command

- don't ever ever run a jupyter lab without a password

`jupyter-lab --ip 0.0.0.0 --port 10123 --allow-root`

browse your jupyter on local machine at: localhost:10123

#TODO: buildaj cuda image iz source za tocno onu arhitekturu/cuda compute koja nan triba https://gitlab.com/nvidia/container-images/cuda idk di san to cita

## Tensorboard command

- be mindful of the sizes of your tensorboard experiments, they can grow quite big if you're not careful about your logging frequencies
  `tensorboard --logdir skala_manje_dugi_exp/ --port 10123 --bind_all`
