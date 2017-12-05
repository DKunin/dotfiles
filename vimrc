set nocompatible
filetype indent plugin on
syntax on
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')
Plug 'josudoey/vim-eslint-fix'
Plug 'vim-syntastic/syntastic'
call plug#end()

let g:syntastic_javascript_checkers=['eslint']

set hidden
set wildmenu
set showcmd
set hlsearch 
 
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nostartofline
set ruler
set confirm
set visualbell
set t_vb=
set mouse=a
set cmdheight=2
set number
set notimeout ttimeout ttimeoutlen=200

set shiftwidth=4
set tabstop=4
set columns=100

map Y y$
nnoremap <C-L> :nohl<CR><C-L>
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
