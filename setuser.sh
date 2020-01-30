#!/bin/bash

set -u

# Setup user if this is the first run
CONTAINER_ALREADY_STARTED="/etc/container_already_started"
USER_HOME=/home/$NAME

if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
	groupadd --gid $GID $NAME
	adduser --uid $ID --gid $GID --disabled-password --gecos '' $NAME
	adduser $NAME sudo
	echo "$NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$NAME
	chmod 0440 /etc/sudoers.d/$NAME

	SHELL_CFG=$USER_HOME/.shell_cfg.bash

	echo 'source /usr/share/bash-completion/completions/git' >> $SHELL_CFG 

	# optionally set a common group
	if [[ -v DS_ID ]]; then
		groupadd --gid $DS_ID "velebit"
		adduser $NAME "velebit"
		echo "User $NAME added to the velebit group with ID $DS_ID"
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
	PYENV_DIR="$USER_HOME/.pyenv"
	if [ -d "$PYENV_DIR" ]; then
		echo "Directory $PYENV_DIR already exists, skipping pyenv installation."
	else
		su $NAME -c "curl https://pyenv.run | bash"
		echo "export PATH=$PYENV_DIR/bin:$PATH" >> $SHELL_CFG 
		echo 'eval "$(pyenv init -)"' >> $SHELL_CFG 
		echo 'eval "$(pyenv virtualenv-init -)"' >> $SHELL_CFG
		echo "Installed pyenv to $PYENV_DIR"
	fi

	# Setup virtualenvwrapper config
	echo "VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> $SHELL_CFG
	echo "export WORKON_HOME=$USER_HOME/.virtualenvs" >> $SHELL_CFG
	echo "export PROJECT_HOME=$USER_HOME/Devel" >> $SHELL_CFG
	echo "source /usr/local/bin/virtualenvwrapper.sh" >> $SHELL_CFG

	# Source shell config file from the .bashrc 
	echo "source $SHELL_CFG" >> $USER_HOME/.bashrc

	# mark first container run
	touch $CONTAINER_ALREADY_STARTED
fi

# change user
cd $USER_HOME
su $NAME

