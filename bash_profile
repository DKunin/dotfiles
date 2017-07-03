[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f ~/.bash.d/cheat.sh ] && . ~/.bash.d/cheat.sh 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

source $HOME/.env
source $HOME/.aliases
source $HOME/.functions
source $HOME/.localenv
source $HOME/.bash-prompt
source /usr/local/etc/bash_completion.d/pass
HISTSIZE= HISTFILESIZE=
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"

# Some shells let us configure their window title. Take advantage of that to
# display the current working directory. Remote (ssh) shels also include the
# hostname.
if [[ $TERM == "xterm"* ]]; then
    if [ -n "$SSH_CONNECTION" ]; then
        PS1="\[\e]0;\h:\w\a\]$PS1"
    else
        PS1="\[\e]0;\w\a\]$PS1"
    fi
fi