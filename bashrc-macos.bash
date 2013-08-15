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
#echo "$(uname -sr), $(uname -m); $(uname -n)"
#echo "Successful login. Welcome, $USER. (^_^);;"

#### Environment Variables ####

# Set Prompt Variable
PS1='\u@\h:\w\$ '

#### Customised Commands and Scripts ####

# Custom Commands
alias ll="ls -alF"
alias lll="ls -alF | less"

# SSHFS Drive
alias mountrimu="bash ~/.scripts/mountrimu.bash"

### Functions ###

# Get External IP; Send to GreyRimu
function sendip() {
   #ipSource="ifconfig.me"
   ipSource="icanhazip.com"
   curl -s "$ipSource" > "$HOME/.daxmacip" || return 1
   rsync -avzqe ssh "$HOME/.daxmacip" 'grey@rimu:~/.ssh/'
}
