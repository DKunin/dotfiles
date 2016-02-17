# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
plugins=(git, common-aliases)

# User configuration

export PATH="$HOME/.nvm/versions/node/v4.0.0/bin/node:$HOME/.nvm/versions/node/v4.0.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

export NODE_PATH="$HOME/.nvm/versions/node/v4.0.0/bin/node"
export PROJECTS="$HOME/Projects"

local ret_status="%(?:%{$fg_bold[green]%} :%{$fg_bold[red]%}➜ %s)"
PROMPT='🐙${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
