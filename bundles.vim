set nocompatible
filetype off

" Vundle setup
set rtp+=~/.vim/bundle/Vundle.vim/
"Start
call vundle#begin()
Bundle 'VundleVim/Vundle.vim'

" General enhancements
Bundle 'tpope/vim-abolish.git'
Bundle 'tpope/vim-characterize.git'
Bundle 'tpope/vim-commentary.git'
Bundle 'tpope/vim-dispatch.git'
Bundle 'tpope/vim-eunuch.git'
Bundle 'tpope/vim-fugitive.git'
Bundle 'tpope/vim-rhubarb'
Bundle 'tpope/vim-ragtag.git'
Bundle 'tpope/vim-repeat.git'
Bundle 'tpope/vim-scriptease.git'
Bundle 'tpope/vim-sensible.git'
" Bundle 'scrooloose/nerdtree.git'
Bundle 'tpope/vim-sleuth.git'
Bundle 'tpope/vim-surround.git'
Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-tbone.git'
Bundle 'tpope/vim-unimpaired.git'
Bundle 'tpope/vim-projectile.git'
Bundle 'airblade/vim-gitgutter'
Bundle 'mattn/gist-vim'
Bundle 'pangloss/vim-javascript.git'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim.git'
Bundle 'elzr/vim-json'
Bundle 'godlygeek/tabular.git'
Bundle 'vim-scripts/vimwiki.git'
" Bundle 'scrooloose/syntastic'
Bundle 'w0rp/ale'
" Bundle 'klen/python-mode'
Bundle 'janko-m/vim-test'
Bundle 'Yggdroot/indentLine'
" extra
Bundle 'henrik/vim-indexed-search'
" Bundle 'craigemery/vim-autotag'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'
" Bundle 'SirVer/ultisnips'
Bundle 'fatih/vim-go'
" Optional:
Bundle 'ggreer/the_silver_searcher'
Bundle 'davidhalter/jedi-vim'
Bundle 'Shougo/neocomplete.vim'
Bundle 'stephpy/vim-yaml'

" Custom textobjects
Bundle 'kana/vim-textobj-user.git'
Bundle 'kana/vim-textobj-entire.git'

" Colorschemes
Bundle 'altercation/vim-colors-solarized.git'
Bundle 'nelstrom/vim-mac-classic-theme.git'
Bundle 'nelstrom/vim-blackboard.git'

" Ruby enhancements
Bundle 'tpope/vim-bundler.git'
Bundle 'tpope/vim-endwise.git'
Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-rake.git'
Bundle 'vim-ruby/vim-ruby'
Bundle 'nelstrom/vim-textobj-rubyblock.git'

" Latex
Bundle 'lervag/vimtex'

" Markdown
Bundle 'tpope/vim-markdown.git'

call vundle#end()
" End
filetype plugin indent on
