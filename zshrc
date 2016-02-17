# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git, common-aliases)

# User configuration

export PATH="$HOME/.nvm/versions/node/v4.0.0/bin/node:$HOME/.nvm/versions/node/v4.0.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

export NODE_PATH="$HOME/.nvm/versions/node/v4.0.0/bin/node"
export PROJECTS="$HOME/Projects"
