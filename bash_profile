export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

source $HOME/.env
source $HOME/.aliases
source $HOME/.functions
source $HOME/.localenv
source $HOME/.bash-prompt
HISTSIZE= HISTFILESIZE=
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"
