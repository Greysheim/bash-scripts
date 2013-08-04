# If not running interactively, don't do anything
[ -z "$PS1" ] && return

##
# DELUXE-USR-LOCAL-BIN-INSERT
# (do not remove this comment)
##
echo $PATH | grep -q -s "/usr/local/bin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/usr/local/bin
    export PATH
fi

#### MotD ####
echo
echo "`uname -sr`, `uname -m`; `uname -n`"
echo "Successful login. Welcome, $USER. (^_^);;"
echo

#### Environment Variables ####

# Set Prompt Variable
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
PS1='\h:\W \u\$ '

#### Customised Commands and Scripts ####

# Custom Commands
alias ll="ls -alF"
alias lll="ls -alF | less"

# SSHFS Drive
alias mountrimu="bash ~/.scripts/mountrimu.bash"
