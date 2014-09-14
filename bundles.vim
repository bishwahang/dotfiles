set nocompatible
filetype off

" Vundle setup
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" General enhancements
Bundle 'tpope/vim-abolish.git'
Bundle 'tpope/vim-characterize.git'
Bundle 'tpope/vim-commentary.git'
Bundle 'tpope/vim-dispatch.git'
Bundle 'tpope/vim-eunuch.git'
Bundle 'tpope/vim-fugitive.git'
Bundle 'tpope/vim-ragtag.git'
Bundle 'tpope/vim-repeat.git'
Bundle 'tpope/vim-scriptease.git'
Bundle 'tpope/vim-sensible.git'
Bundle 'tpope/vim-sleuth.git'
Bundle 'tpope/vim-surround.git'
Bundle 'tpope/vim-tbone.git'
Bundle 'tpope/vim-unimpaired.git'
Bundle 'tpope/vim-projectile.git'

Bundle 'mattn/gist-vim'
Bundle 'pangloss/vim-javascript.git'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim.git'
Bundle 'elzr/vim-json'
Bundle 'godlygeek/tabular.git'
Bundle 'vim-scripts/vimwiki.git'

"extra
Bundle 'henrik/vim-indexed-search'
Bundle 'craigemery/vim-autotag'

" Custom textobjects
Bundle 'kana/vim-textobj-user.git'
Bundle 'kana/vim-textobj-entire.git'
Bundle 'kana/vim-textobj-indent.git'
Bundle 'kana/vim-textobj-syntax.git'
Bundle 'kana/vim-textobj-line.git'
Bundle 'nelstrom/vim-textobj-rubyblock.git'

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

" Markdown
Bundle 'tpope/vim-markdown.git'

filetype plugin indent on

