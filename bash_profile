[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f ~/.bash.d/cheat.sh ] && . ~/.bash.d/cheat.sh 
[ -f ~/.fzf.bash ] && . ~/.fzf.bash
[ -f /usr/local/etc/bash_completion.d/pass ] && . /usr/local/etc/bash_completion.d/pass

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

source $HOME/.env
source $HOME/.aliases
source $HOME/.functions
source $HOME/.localenv
source $HOME/.bash-prompt
HISTSIZE= HISTFILESIZE=
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"