# TensorPix Research Docker

## Connecting to remote machines via ssh

To connect to the server via ssh and forward the ports for jupyter lab and tensorboard, you can use the following command:
- port 141 is the port on the server where the ssh is running
- port 10123 is forwarded for jupyter lab
- dumps all error msgs in to sshdump (error3 connection refused was getting spammed in the terminal bcs of the port forwarding idk idc)


```bash
ssh -p 141 -L 10123:localhost:10123 -E sshdump <USER>@<IP>
```

### ssh config

You can add the following to your `~/.ssh/config` file to make the ssh command shorter:

```bash
Host komp-ured
    Port 141 # change this to the port of the server
    HostName 127.0.0.1 # change this to the ip of the server
    User ivica # change your name to ivica in real life
```

## Building the docker image

Position yourself in the root directory whcih contains the Dockerfile and setuser.sh

```bash
basename $(pwd) # should print 'ai-docker'
```

Run the following command to build the docker image:

```bash
docker build -t research-image .
```

## Create a docker container

To run the docker container, you can use the template down bellow. This command does the follownig:
- forwards the ports `6006` and `10123` which is used for tensorboard and jupyter lab respectively. Of course, someone else might use these ports on the host machine, so you can change them to whatever you want.
- mounts 3 different directories (dataset, code, experiments) from the host machine to the container
- sets the environment variables for the user and group id. This is nice because the user in the container will have the same id as the user on the host machine. This way, the permissions are not messed up when you create files in the mounted directories

```
docker run \
-it --ipc=host --ulimit memlock=-1 --gpus all \
-p <PORT>:<PORT> --name=$USER-research \
-v <HOST_DIRECTORY>:<CONTAINER_DIRECTORY> \
-e NAME=$USER -e ID=$UID -e GID=1001 -e DS_ID=1004 \
research-image
```

A concrete working example:

```bash
docker run -it -p 6006:6006 -p 10123:10123 --name=$USER-research --gpus all --ipc=host --ulimit memlock=-1 -v /data:/data -v ~/experiments:/home/$USER/experiments -v ~/code:/home/$USER/code -e NAME=$USER -e ID=$UID -e GID=1001 -e DS_ID=1004 research-image
```

To remove the container, you can use the following command:

```bash
docker stop $USER-research; docker rm $USER-research
```

## Attaching to a running container

If you want to attach to shell of a running container you can use the following command. Note, this won't start a new shell:

```bash
docker attach $USER-research
```

## Opening a new shell

this is for opening mulitple shells in the same container and not messing up the permissions. rwx permissions should work as intended here with the user:group -> user is your user and group is aimages(1004). userid and groupid are set in the docker run command above. as ID and DS_ID respectively.

```bash
docker exec -it $(whoami)-research bash
```

## Jupyter lab command

> ❗ Don't run a jupyter lab without setting up a password. We don't want to leak experiments and data examples
>
> See: https://jupyter-notebook.readthedocs.io/en/5.6.0/public_server.html#automatic-password-setup

Run the following command inside of the docker container:

```bash
jupyter-lab --ip 0.0.0.0 --port 10123 --allow-root
```

You can now browse jupyter on your local machine in the browser at `localhost:10123`. This works because we forwarded the port 10123 in the docker run command. If the local machine is actually remote, make sure you forward the 10123 port via the ssh as well.

#TODO: buildaj cuda image iz source za tocno onu arhitekturu/cuda compute koja nan triba https://gitlab.com/nvidia/container-images/cuda idk di san to cita

## Tensorboard command

> ⚠️ be mindful of the sizes of your tensorboard experiments, they can grow quite big if you're not careful about your logging frequencies

Run the following command inside of the docker container:

```bash
tensorboard --logdir skala_manje_dugi_exp/ --port 10123 --bind_all
```