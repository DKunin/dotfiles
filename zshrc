source $HOME/.env
plugins=(git, common-aliases, sublime)
source $ZSH/oh-my-zsh.sh
source $(brew --prefix autoenv)/activate.sh

source $HOME/.aliases
source $HOME/.functions
source $HOME/.prompt
source $HOME/.localenv
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"
