#!/usr/bin/env bash

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f ~/.bash.d/cheat.sh ] && . ~/.bash.d/cheat.sh
[ -f ~/.fzf.bash ] && . ~/.fzf.bash
[ -f /usr/local/etc/bash_completion.d/pass ] && . /usr/local/etc/bash_completion.d/pass
[ -f $DOTFILES/completions/adb ] && . $DOTFILES/completions/adb

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  _clean_path=
  _old_ifs="$IFS"
  IFS=':'
  for _path_entry in $PATH; do
    case "$_path_entry" in
      "$NVM_DIR"/versions/*/bin) ;;
      *)
        if [ -n "$_clean_path" ]; then
          _clean_path="${_clean_path}:$_path_entry"
        else
          _clean_path="$_path_entry"
        fi
      ;;
    esac
  done
  IFS="$_old_ifs"
  unset _old_ifs _path_entry
  export PATH="$_clean_path"
  unset _clean_path
  . "$NVM_DIR/nvm.sh" --no-use
fi

. $HOME/.env
. $HOME/.aliases
. $HOME/.functions
. $HOME/.localenv
. $HOME/.bash-prompt
. $HOME/.profile
# export PATH=${PATH}:/usr/bin/python3
export PYTHON="/opt/homebrew/opt/python@3.11/bin/python3.11"
HISTSIZE=
HISTFILESIZE=
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"

# Don't check mail when opening terminal.
unset MAILCHECK
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
# export PATH="/usr/local/opt/go@1.19/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# . "$HOME/.local/bin/env"

# The next line updates PATH for CLI.
if [ -f '/Users/dkunin/yandex-cloud/path.bash.inc' ]; then source '/Users/dkunin/yandex-cloud/path.bash.inc'; fi
# The next line enables shell command completion for yc.
if [ -f '/Users/dkunin/yandex-cloud/completion.bash.inc' ]; then source '/Users/dkunin/yandex-cloud/completion.bash.inc'; fi


eval "$(/opt/homebrew/bin/brew shellenv)"

alias stt="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"

export PATH="$HOME/go/bin:$PATH"

export PATH="$(brew --prefix openjdk)/bin:$PATH"
export JAVA_HOME="$(brew --prefix openjdk)/libexec/openjdk.jdk/Contents/Home"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

nvm use default --delete-prefix --silent >/dev/null 2>&1 || nvm use default
