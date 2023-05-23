#!/bin/bash

set -u

# Setup user if this is the first run
CONTAINER_ALREADY_STARTED="/etc/container_already_started"
USER_HOME=/home/$NAME

#this part of the script uses 3 env variable passed as -e when running the docker container
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then

	groupadd --gid $GID $NAME
	adduser --uid $ID --gid $GID --disabled-password --gecos '' $NAME
	adduser $NAME sudo
	echo "$NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$NAME
	chmod 0440 /etc/sudoers.d/$NAME

	# optionally set a common group
	if [[ -v DS_ID ]]; then
		groupadd --gid $DS_ID "aimages"
		adduser $NAME "aimages"
		echo "User $NAME added to the aimages group with ID $DS_ID"
	fi


	SHELL_CFG=$USER_HOME/.shell_cfg.bash

	echo 'source /usr/share/bash-completion/completions/git' >> $SHELL_CFG

	# Setup virtualenvwrapper config
	echo "VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> $SHELL_CFG
	echo "export WORKON_HOME=$USER_HOME/.virtualenvs" >> $SHELL_CFG
	echo "export PROJECT_HOME=$USER_HOME/Devel" >> $SHELL_CFG
	echo "source /usr/local/bin/virtualenvwrapper.sh" >> $SHELL_CFG

	# Source shell config file from the .bashrc
	echo "source $SHELL_CFG" >> $USER_HOME/.bashrc

	# mark first container run
	touch $CONTAINER_ALREADY_STARTED
	#mkdir $USER_HOME/code
	#mkdir $USER_HOME/data
	#mkdir $USER_HOME/experiments
	chown -R $NAME:$DS_ID $USER_HOME
fi

#set user default grp to the one provided by DS_ID
usermod $NAME -g $DS_ID
# change user
cd $USER_HOME
su $NAME
