set nocompatible              " be iMproved, required
filetype off                  " required

" ==== Plugin-Manager =============================================================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins, the short-hand form here assumes that it is on github.com
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'flazz/vim-colorschemes'
Plugin 'powerline/fonts'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

"Plugin 'scrooloose/syntastic'
"Plugin 'nathanaelkane/vim-indent-guides'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" ==== Plugin Configuration =======================================================================

" ==== vim-airline
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts=1
let g:airline_statusline_ontop=1

" ==== General Configuration ======================================================================
set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink

" ==== Enable syntax high-light ===================================================================
syntax on
let g:solarized_termcolors=16
set t_Co=16
set background=dark
colorscheme solarized

" ==== Reload files changed outside vim ===========================================================
set autoread

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" ==== Scrolling ==================================================================================
" = Start scrolling when 'scrollloff' lines away from top/bottom
" = and 'sidescrollloff' characters from top/bottom
set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" ==== Turn Off Swap Files ========================================================================
set noswapfile
set nobackup
set nowb

" ====  Persistent Undo ===========================================================================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ==== Indentation ================================================================================
set autoindent
set smartindent
set smarttab
set shiftwidth=8
set softtabstop=8
set tabstop=8

" ==== Indentation: file-specific =================================================================
autocmd BufEnter *.css :setlocal filetype=html
autocmd BufEnter *.cu :setlocal filetype=cpp
autocmd BufEnter *.h :setlocal filetype=c
autocmd BufEnter *.html :setlocal filetype=html
autocmd BufEnter *.js :setlocal filetype=html
autocmd BufEnter *.json :setlocal filetype=html
autocmd BufEnter *.plan :setlocal filetype=yaml
autocmd BufEnter *.preseed :setlocal ts=4 sw=4 expandtab
autocmd BufEnter *.sh :setlocal ts=2 sw=2 expandtab
autocmd BufEnter *.suite :setlocal filetype=shell
autocmd Filetype c setlocal ts=8 sw=8 textwidth=99 noexpandtab
autocmd Filetype cpp setlocal ts=2 sw=2 expandtab
autocmd Filetype html setlocal ts=2 sw=2 expandtab textwidth=99
autocmd Filetype js setlocal ts=2 sw=2 expandtab textwidth=99
autocmd Filetype markdown setlocal ts=4 sw=4 expandtab
autocmd Filetype python setlocal ts=4 sw=4 textwidth=79 autoindent fileformat=unix expandtab
autocmd Filetype rst setlocal ts=2 sw=2 expandtab textwidth=79 wrapmargin=0 formatoptions=nt
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
autocmd Filetype shell setlocal textwidth=0 wrapmargin=0
autocmd Filetype yaml setlocal ts=2 sw=2 expandtab

" ==== Indentation: display tabs and trailing spaces visually =====================================
set list listchars=tab:»·,trail:·,extends:$,nbsp:=
set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ==== Redrawing ==================================================================================
set lazyredraw
set ttyfast

" ==== yank to clipboard ==========================================================================
set clipboard=unnamedplus
set clipboard^=unnamed

" ==== Wrapping ===================================================================================
set formatoptions+=t colorcolumn=+1 tw=80
set formatoptions+=t colorcolumn=+1 tw=99

" ==== Display tabs and trailing spaces visually ==================================================
set list listchars=tab:»·,trail:·,extends:$,nbsp:=

" ==== Use vim-built-in file-browser (netrw) in a NERDTree-like fashion ===========================
nmap <silent> <f2> :Lexplore<cr>
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" ==== tags: search upwards for tags file ===========
set tags=~/tags/xnvme,~/tags/spdk,./tags;/

" ==== Disabled options ===========================================================================
" set visualbell                  "No sounds
