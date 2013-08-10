# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history. See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

##### Daniel Cranston's Additions #####

### SSH ###
eval $(ssh-agent) &> /dev/null
ssh-add ~/.ssh/greyrimu_github_rsa &> /dev/null

### Tmux ###
# Set default directory for new windows to home directory
tmux set-option default-path ~ > /dev/null

# Auto-attach
if [ -z "$(ps ux | grep "tmux" | grep -v "grep")" ]; then
    echo "[tmux: starting]"
    tmux
elif [ -z "$TMUX" ]; then
    echo "[tmux: attaching]"
    tmux attach
fi 

###Aliases###
alias ll='ls -alF'
alias lll='ls -alF | less'

###Scripts###
alias mcrun='callDir=$PWD; cd ~/minecraft/server && ./run; cd $callDir; unset callDir'
alias mckill='kill -9 $(ps x | grep "[m]inecraft" | awk '"'"'{print $1}'"'"')'
alias tma='tmux attach'
alias cllog='tail -20 ~/.scripts/cron/checklines.run.log | less'

### Functions ###

#Set window title (tmux, etc)
settitle() {
    printf "\033k$1\033\\"
}
