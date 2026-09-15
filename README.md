# DKunin's personal dotfiles, functions, quirks and settings

# TemperMonkey Scripts
- stash-editor-jump : adds input field to stash for you to specify folder and use it with: [menubar-helper](https://github.com/DKunin/menubar-helper)

# bitplugins
- days : Display number of days, since you were born
- dirty : Get dirty projects (not staged, or non commited)
- prs : Pull requests list
- user : Wakatime info
- week : Displays current week number

# xbar

- `codex-limit.5m.sh` — показывает оставшийся лимит Codex и время сброса квоты. Запрос выполняется через SOCKS5-профиль приложения «Telegram via SOCKS», а авторизация читается из `~/.codex/auth.json`.

Для установки создайте ссылку в каталоге плагинов xbar:

```console
ln -s "$DOTFILES/xbar/codex-limit.5m.sh" "$HOME/Library/Application Support/xbar/plugins/codex-limit.5m.sh"
```

Пути можно переопределить переменными `CODEX_AUTH_FILE` и `SOCKS_PROXY_CONFIG`.

## Виджет Codex Limit для macOS

Каталог `macos-widget` содержит нативное приложение с расширением WidgetKit для боковой панели «Центр уведомлений». Виджет показывает оставшийся основной лимит Codex и время сброса, используя те же файлы авторизации и SOCKS5-профиля.

Сборка и установка:

```console
cd "$DOTFILES/macos-widget"
./install.sh
```

После запуска приложения `Codex Limit` откройте «Центр уведомлений» → «Изменить виджеты» и добавьте `Codex Limit` в боковую панель. Нажатие на виджет сразу запрашивает свежие данные. WidgetKit также запрашивает обновление примерно каждые пять минут, но macOS может изменить фактический интервал.

# sublime
- TodoReview: Settings for TodoReview plugin
- Snippets: snippets for sublime stuff, to link:
```console
ln -s $DOTFILES/sublime/snippets /Users/USER/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
ln -s $DOTFILES/sublime/SETTINGS_FILE /Users/USER/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

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

# Shell-функции

## uploadVideo

Загружает видео в каталог `Videos` файлового сервера через SSH. Передача выполняется через `rsync`, поэтому прерванную загрузку большого файла можно продолжить повторным запуском команды.

```console
uploadVideo "/путь/к/video.mp4"
```

После изменения dotfiles обновите текущую Bash-сессию:

```console
source ~/.bash_profile
```

# completion file location

## Darwin
```
    /usr/local/etc/bash_completion.d/
```

## Linux
```
    /etc/bash_completion.d/
```
