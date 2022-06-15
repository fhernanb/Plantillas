#!/bin/bash
# bash which will be invoked with source (.) on login
# author: Jan Hybs

# source bash_completion
if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

alias ll="ls -lah"
export PATH=$PATH:/opt/flow123d/flow123d/bin:/opt/flow123d/bin