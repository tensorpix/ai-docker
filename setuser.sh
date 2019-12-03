#!/bin/bash

set -u

# Setup user if this is the first run
CONTAINER_ALREADY_STARTED="/etc/container_already_started"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
	groupadd --gid $GID $NAME
	adduser --uid $ID --gid $GID --disabled-password --gecos '' $NAME
	adduser $NAME sudo
	echo "$NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$NAME
	chmod 0440 /etc/sudoers.d/$NAME

	SHELL_CFG=/home/$NAME/.shell_cfg.bash

	echo 'source /usr/share/bash-completion/completions/git' >> $SHELL_CFG 

	# optionally set a common datascience group
	if [[ -v DS_ID ]]; then
		groupadd --gid $DS_ID "datascience"
		adduser $NAME "datascience"
		echo "User $NAME added to the datascience group with ID $DS_ID"
	fi

	# setup code path if CODE_PATH set
	if [[ -v CODE_PATH ]]; then
		echo "CODE_PATH=$CODE_PATH" >> $SHELL_CFG 
		path=\$CODE_PATH/research/vision:
		path+=\$CODE_PATH/external-projects
		echo "export PYTHONPATH=$path" >> $SHELL_CFG 
		echo "Set code path to $CODE_PATH"
	fi

	# Install pyenv if it doesn't exist in the home folder
	PYENV_DIR="/home/$NAME/.pyenv"
	if [ -d "$PYENV_DIR" ]; then
		echo "Directory $PYENV_DIR already exists, skipping pyenv installation."
	else
		su $NAME -c "curl https://pyenv.run | bash"
		echo "export PATH=$PYENV_DIR/bin:$PATH" >> $SHELL_CFG 
		echo 'eval "$(pyenv init -)"' >> $SHELL_CFG 
		echo 'eval "$(pyenv virtualenv-init -)"' >> $SHELL_CFG
		echo "Installed pyenv to $PYENV_DIR"
	fi

	# Source shell config file from the .bashrc 
	echo "source $SHELL_CFG" >> /home/$NAME/.bashrc

	# mark first container run
	touch $CONTAINER_ALREADY_STARTED
fi

# change user
cd /home/$NAME
su $NAME

