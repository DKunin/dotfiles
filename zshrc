source $HOME/.env
plugins=(git, common-aliases, zsh-wakatime, sublime)
source $ZSH/oh-my-zsh.sh

source $HOME/.localenv
source $HOME/.aliases
source $HOME/.functions
source $HOME/.prompt
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"