# DKunin's personal dotfiles, functions, quirks and settings

# bitplugins
- days : Display number of days, since you were born
- dirty : Get dirty projects (not staged, or non commited)
- prs : Pull requests list
- user : Wakatime info
- week : Displays current week number

# sublime
- TodoReview: Settings for TodoReview plugin
- Snippets: snippets for sublime stuff, to link:
```console
ln -s $DOTFILES/sublime/snippets /Users/USER/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

```

# root
- alisases - selfexplanatory :)
- editorconfig - Config for Sublime Text Editor
- env - Main enviroment variables, settings and shortcuts
- eslint - My common eslint settings
- functions - functions that were not fit for alias, or for a bin
- gitconfig - My common gitconfig
- jscsrc - My common jscs settings
- mouse-trap-todoist-setting.js - Mousetrap bindings for my Todoist wrapper, if this files is cnahged - all linked apps change their bindings as well
- npm-init - npm init additional logic, cam be setup with:
```
npm config set init-module ~/.npm-init.js
```
- osx - osx specific quirks
- phoenix - phoenix window positioning app settings
- README - this file )
- StarterKis.json - settings file for npm propel
- vimrc - vim configuration file
- zprofile - profile for zsh
- zshrc - zsh configuration