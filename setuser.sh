#!/bin/bash
set -u

# Setup user if this is the first run
CONTAINER_ALREADY_STARTED="/etc/container_already_started"
USER_HOME="/home/$NAME"
PYENV_DIR="$USER_HOME/.pyenv"

if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
	groupadd --gid $GID $NAME
	adduser --uid $ID --gid $GID --disabled-password --gecos '' $NAME
	adduser $NAME sudo
	echo "$NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$NAME
	chmod 0440 /etc/sudoers.d/$NAME
	cp /etc/skel/.bashrc $USER_HOME/.bashrc # copy default .bashrc, otherwise .bashrc is empty file
	chown -R $NAME:$NAME $USER_HOME # change ownership of home directory to the new user
	
	# optionally set a common group
	if [[ -v DS_ID ]]; then
		groupadd --gid $DS_ID "tensorpix"
		adduser $NAME "tensorpix"
		echo "User $NAME added to the tensorpix group with ID $DS_ID"
	fi

	# Install pyenv if it doesn't exist in the home folder
	if [ -d "$PYENV_DIR" ]; then
		echo "Directory $PYENV_DIR already exists, skipping pyenv installation."
	else
		su $NAME -c "curl https://pyenv.run | bash"
		echo "export PYENV_ROOT=\"${PYENV_DIR}\"" >> $USER_HOME/.bashrc
		echo "command -v pyenv >/dev/null || export PATH=\"$PYENV_DIR/bin:$PATH\"" >> $USER_HOME/.bashrc
		echo 'eval "$(pyenv init -)"' >> $USER_HOME/.bashrc
		echo "Installed pyenv to $PYENV_DIR"
	fi
	
	# Add git completion to bashrc
	lines_to_add='if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	fi'
	echo "$lines_to_add" >> $USER_HOME/.bashrc

	# mark first container run
	touch $CONTAINER_ALREADY_STARTED
fi

# change user
cd $USER_HOME
su $NAME -s /bin/bash