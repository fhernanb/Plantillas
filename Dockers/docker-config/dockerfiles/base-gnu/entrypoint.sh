#!/bin/bash

# entrypoint script which will be invoked after
# docker run call
# can be overridfen with docker run --entrypoint=/bin/bash 


# Make sure only root can run our script
# otherwise just forward args to /bin/bash and do nothing
if [[ $EUID -eq 0 ]]; then
  USER_UID=${uid:-1000}
  USER_GID=${gid:-$USER_UID}
  USER_WHO=${who:-flow}
  
  # specify home location from which some files can be copied
  USER_HOME=${home}
  GOSU_HOME=/home/$USER_WHO
  
  # terminal look&feel
  theme=${theme:-light}
  
  #c reate groupd and user
  groupadd --gid $USER_GID \
           --non-unique \
            $USER_WHO
  useradd --shell /bin/bash \
           --uid $USER_UID \
           --gid $USER_GID \
           --non-unique \
           --create-home $USER_WHO
  
  # enable sudo
  cat >> /etc/sudoers << EOL
$USER_WHO ALL=NOPASSWD: ALL
EOL
  
  # if USER_HOMEw as set try to copy some files
  if [[ -n "$USER_HOME" ]]; then
    # copies files/folders from
    # $USER_HOME to $GOSU_HOME
    files=(".gitconfig" ".bash_history" ".ssh")
    for i in "${files[@]}"
    do
      from=$USER_HOME/$i
      to=$GOSU_HOME/$i
      
      if [[ -f "$from" ]]; then
        cp $from $to
        chown -R $USER_WHO:$USER_WHO $to
      elif [[ -d "$from" ]]; then
        cp -r $from $to
        chown -R $USER_WHO:$USER_WHO $to
      fi
    done
  fi
  
  # Color definition
  bldgrn='\e[1;32m' # Green
  bldylw='\e[1;33m' # Yellow
  bldblu='\e[1;34m' # Blue
  bldpur='\e[1;35m' # Purple
  txtrst='\e[m' # Text Reset

  # edit main bash.bashrc file
  cat >> $GOSU_HOME/.bashrc << EOL
export HOME="\${home#/mnt/}"

# add flow123d bashcompletion
function _flow123d() {
  local cur=\${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=(\$(compgen -df -W "-s -i -o -l \
        --solve --input_dir --output_dir --log --version \
        --no_log --no_signal_handler --no_profiler --help \
        --input_format --petsc_redirect --yaml_balance" -- \$cur))
  return 0
}
# add runtest bashcompletion
function _runtest() {
  local cur=\${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=(\$(compgen -df -W "--keep-going \
        --batch --cpu --limit-time --limit-memory \
        --no-clean --no-compare --death-test --help \
        --list" -- \$cur))
  return 0
}
complete -o nospace -F _flow123d flow123d
complete -o nospace -F _runtest runtest
version=\$(cat /.dockerversion)
short_version=\${version/Debug/dbg}
short_version=\${short_version/Release/rel}

if [[ "$theme" == "light" ]]; then
  export PS1="${bldgrn}\${short_version}${bldylw} \w ${txtrst}"
elif [[ "$theme" == "dark" ]]; then
  #export PS1="${bldpur}\u${txtrst}@${bldpur}flow:\${short_version}${bldblu} \w ${txtrst}"  # Problems with line editting.
  export PS1="${bldpur}\${short_version}${bldblu} \w ${txtrst}"
else
  export PS1="\${short_version} \w "

fi

# clear the terminal
printf '\033[2J'
echo " ___ _            _ ___ ____    _ "
echo "| __| |_____ __ _/ |_  )__ / __| |"
echo "| _|| / _ \ V  V / |/ / |_ \/ _  |"
echo "|_| |_\___/\_/\_/|_/___|___/\__,_|"
echo "                         \$version"

EOL
  
  # switch to the user and execute what was given
  exec /usr/sbin/gosu $USER_WHO "$@"
else
  # execute what was given
  exec /bin/bash "$@"
fi
