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

    SHELL_RC_FILE=".bashrc"
    if [[ -v USE_ZSH ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    else
        # bash git completion
        echo "source /usr/share/bash-completion/completions/git" >> /home/$NAME/$SHELL_RC_FILE
    fi

    # optionally set a common datascience group
    if [[ -v DS_ID ]]; then
        groupadd --gid $DS_ID "datascience"
        adduser $NAME "datascience"
    fi

    # setup code path if CODE_PATH set
    if [[ -v CODE_PATH ]]; then
        echo "CODE_PATH=$CODE_PATH" >> /home/$NAME/$SHELL_RC_FILE
        path=\$CODE_PATH/research/vision:
        path+=\$CODE_PATH/external-projects
        echo "export PYTHONPATH=$path" >> /home/$NAME/$SHELL_RC_FILE
    fi

    # mark first container run
    touch $CONTAINER_ALREADY_STARTED
fi

# change user
cd /home/$NAME
su $NAME
