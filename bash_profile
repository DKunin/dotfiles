#!/usr/bin/env bash

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f ~/.bash.d/cheat.sh ] && . ~/.bash.d/cheat.sh
[ -f ~/.fzf.bash ] && . ~/.fzf.bash
[ -f /usr/local/etc/bash_completion.d/pass ] && . /usr/local/etc/bash_completion.d/pass
[ -f $DOTFILES/completions/adb ] && . $DOTFILES/completions/adb

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

. $HOME/.env
. $HOME/.aliases
. $HOME/.functions
. $HOME/.localenv
. $HOME/.bash-prompt
. $HOME/.profile

HISTSIZE=
HISTFILESIZE=
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"

nvm use default

# Don't check mail when opening terminal.
unset MAILCHECK
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
