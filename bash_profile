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
export PATH=${PATH}:/usr/bin/python3

HISTSIZE=
HISTFILESIZE=
export HISTIGNORE="ls:ls *:cd:cd -:pwd;exit:date:* --help"

nvm use default

# Don't check mail when opening terminal.
unset MAILCHECK
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="/usr/local/opt/go@1.19/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/dkunin/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/dkunin/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/dkunin/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/dkunin/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

. "$HOME/.local/bin/env"

# The next line updates PATH for CLI.
if [ -f '/Users/dkunin/yandex-cloud/path.bash.inc' ]; then source '/Users/dkunin/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/Users/dkunin/yandex-cloud/completion.bash.inc' ]; then source '/Users/dkunin/yandex-cloud/completion.bash.inc'; fi

