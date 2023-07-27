# Test if internet connection
if : >/dev/tcp/8.8.8.8/53; then
  bashrc_internet=true
  echo "internet working"
else
  bashrc_internet=false
  echo "no internet"
fi

if [ -f ~/.bashrc_conf ]; then
  set bashrc_conf=true
  source ~/.bashrc_conf
else
  # Run bashrc configurator
  set bashrc_conf=false
fi

if [ bashrc_conf]; then
  # Check for bashrc update
  if [ bashrc_autoupdate && bashrc_internet ]; then
    echo "Checking for bashrc update"
  fi
fi

# Set colors
RED='\e[38;5;196m'
GREEN='\e[38;5;82m'
YELLOW='\e[33m'
BLACK='\e[30m'
iGREEN='\e[38;5;82;7m'
iRED='\e[38;5;196;7m'
NO_COLOR='\e[0m'

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

HISTCONTROL=ignoreboth # ignore duplicates and lines starting with space
HISTSIZE=1000 # History size - Default: 500
HISTFILESIZE=2000 # Size of History file

shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize # Check window size and update LINES & COLUMNS after each command

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)" # make less more friendly for non-text input files

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi


force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then # Test if support for colors
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  if [ $(id -u) -eq 0 ]; then # you are root, make the prompt red
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;31m\]\w\[\033[00m\]\$ '
  else # Not root, make prompt green
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  fi
else # No color support
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Docker alias
if [ -x "$(command -v docker)" ]; then 
	# Start the docker-compose stack in the current directory
	alias dcu="docker compose up -d"
	
	# Start the docker-compose stack in the current directory and rebuild the images
	alias dcub="docker compose up -d --build"
	
	# Stop, delete (down) or restart the docker-compose stack in the current directory
	alias dcs="docker compose stop"
	alias dcd="docker compose down"
	alias dcr="docker compose restart"
	
	# Show the logs for the docker-compose stack in the current directory
	# May be extended with the service name to get service-specific logs, like
	# 'dcl php' to get the logs of the php container
	alias dcl="docker compose logs"
	
	# Quickly run the docker exec command like this: 'dex container-name bash'
	alias dex="docker exec -it"

	# Update and restart container
	alias dcpu='docker compose pull && dcu'

	# 'docker ps' displays the currently running containers
	alias dps="docker ps"
	
	# This command is a neat shell pipeline to stop all running containers no matter
	# where you are and without knowing any container names
	alias dsa="docker ps -q | awk '{print $1}' | xargs -o docker stop"
fi

# some more ls aliases
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Apt Updates
alias sysupdate='sudo apt-get -f install && sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean -y && if [ -f /var/run/reboot-required ]; then echo -e "\n${iRED}reboot required${NO_COLOR}\n"; else echo -e "\n${iGREEN}no reboot${NO_COLOR}\n"; fi'

alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# changing dircolors
# inspiration: https://linuxhint.com/ls_colors_bash/
LS_COLORS='rs=0:di=04;94:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

# celebrate login with good fortune!
/usr/games/fortune | /usr/games/cowsay -f /usr/share/cowsay/cows/three-eyes.cow | /usr/games/lolcat