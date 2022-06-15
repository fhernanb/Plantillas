#!/bin/bash
# author: Jan Hybs
#
# this is template file for following docker images
#  - flow-dev-gnu-dbg
#  - flow-dev-gnu-rel
#
# purpose of this file is to create more easy to use
# environment in docker images
# variables surrounded with @ will be replaced later, available variables are:
#     uname     - string username
#     gid       - group id
#     uid       - user id
#     git_email - result from `git config --global user.email`
#     uname - result from `git config --global user.name`
#
# this script will be executed inside running docker container
# right now you are a root with unlimited privileges



# CREATE USER AND GROUP
# ------------------------------------------------------------------------------
echo 'group: @uname@(@gid@)'
echo 'user:  @uname@(@uid@)'

addgroup  --gid @gid@ --force-badname @uname@
adduser   --home /home/@uname@ --shell /bin/bash \
          --uid @uid@ --gid @gid@ \
          --disabled-password --system --force-badname @uname@


# BUILDER COMMANDS
# ------------------------------------------------------------------------------
# create folder where user will have access to
mkdir -p /opt/flow123d/flow123d
chown -R @uid@:@gid@ /opt/flow123d/

# allow sudo for user
cat >> /etc/sudoers  << EOL
@uname@ ALL=NOPASSWD: ALL
EOL

# edit main bash.bashrc file
cat >> /etc/bash.bashrc << EOL
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# shortcuts
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
EOL


# edit .bashrc ($PS1 variable) so the version is visible
image_tag="@image_tag@"
if [[ -z "${image_tag}" ]]; then
    image_tag="@docker_image@"
fi

cat >> /etc/bash.bashrc << EOL
export PS1="\e[1;32m\u\e[0m@\e[0;32m${image_tag}\e[1;33m \w \e[0m\$ "
# clear the terminal  
printf '\033[2J'
echo "___ _            _ ___ ____    _  "
echo "| __| |_____ __ _/ |_  )__ / __| |"
echo "| _|| / _ \ V  V / |/ / |_ \/ _  |"
echo "|_| |_\___/\_/\_/|_/___|___/\__,_|"
echo "                                  "
echo ""
EOL

# copy git configuration
cp -r /tmp/.gitconfig /home/@uname@/

# copy ssh keys
cp -r /tmp/.ssh /home/@uname@/
