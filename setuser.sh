#!/bin/bash

set -u


# Setup user if this is the first run
CONTAINER_ALREADY_STARTED="/etc/container_already_started"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    adduser --uid $ID --disabled-password --gecos '' $NAME
    adduser $NAME sudo
    echo "$NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$NAME
    chmod 0440 /etc/sudoers.d/$NAME

    SHELL_RC_FILE=".bashrc"
    if [[ -v USE_ZSH ]]; then
        SHELL_RC_FILE=".zshrc"
        chmod 0777 /usr/bin/install_oh-my-zsh.sh
        sudo -u $NAME -H sh -c /usr/bin/install_oh-my-zsh.sh
        sed -i 's/ZSH_THEME=.*/ZSH_THEME=gentoo/' /home/$NAME/$SHELL_RC_FILE
    else
        # bash git completion
        echo "source /usr/share/bash-completion/completions/git" >> /home/$NAME/$SHELL_RC_FILE
    fi


    # if $ID not 1000, create user "datascience" with id 1000
    # useful for train machines
    if (($ID != 1000)); then
        DATASCIENCE_USER="datascience"
        adduser --uid 1000 --disabled-password --gecos '' $DATASCIENCE_USER
        adduser $DATASCIENCE_USER sudo
        echo "$DATASCIENCE_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$DATASCIENCE_USER
        chmod 0440 /etc/sudoers.d/$DATASCIENCE_USER
        # add $ID user to datascience group, and vice versa
        adduser $NAME $DATASCIENCE_USER
        adduser $DATASCIENCE_USER $NAME
    fi

    # setup code path if DS_CODE_PATH set
    if [[ -v DS_CODE_PATH ]]; then
        echo "DS_CODE_PATH=$DS_CODE_PATH" >> /home/$NAME/$SHELL_RC_FILE
        path=\$DS_CODE_PATH/computer_vision:
        path+=\$DS_CODE_PATH/ds-common:
        path+=\$DS_CODE_PATH/intermediary:
        path+=\$DS_CODE_PATH/newsletter_personalization:
        path+=\$DS_CODE_PATH/text_analysis:
        path+=\$DS_CODE_PATH/tree_manager
        echo "export PYTHONPATH=$path" >> /home/$NAME/$SHELL_RC_FILE
    fi

    # note first container run
    touch $CONTAINER_ALREADY_STARTED
fi

# change user
cd /home/$NAME
su $NAME
