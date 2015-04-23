" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

"the bundles vim loading
source ~/dotfiles/bundles.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible
" Turn on line numbering. Turn it off with "set nonu" 
set nu
" Higlhight search
set hls

" Wrap text instead of being on one line
set lbr
" no bell or blink on error
set noeb vb t_vb=

" colorscheme
colorscheme solarized
" let g:solarized_termcolors=256
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
let g:solarized_menu=0
if exists('*togglebg#map')
  call togglebg#map("<F5>")
endif
if has('gui_running')
    set background=light
    " GUI is running or is about to start.
    " Maximize gvim window (for an alternative on Windows, see simalt below).
    set lines=999 columns=999
else
    set background=dark
    " This is console Vim.
    " if exists("+lines")
    "   set lines=50
    " endif
    " if exists("+columns")
    "   set columns=100
    " endif
endif
" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Ctlr-P {{{2
let g:ctrlp_jump_to_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'find %s -type f'
" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
 au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif
set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
"filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd            " Show (partial) command in status line.
"set showmatch          " Show matching brackets.
set ignorecase          " Do case insensitive matching
"set smartcase          " Do smart case matching
"set incsearch          " Incremental search
"set autowrite          " Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
set mouse=a             " Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif


"Filetype tabs
autocmd Filetype cpp setlocal expandtab ts=4 sts=4 sw=4
autocmd Filetype html setlocal expandtab ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal expandtab ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal expandtab ts=4 sts=4 sw=4
autocmd FileType python setlocal expandtab ts=4 sts=4 sw=4
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
"Ruby autocomplete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
" map <F8> to generate ctags
"map <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"for CtrlP
" set runtimepath^=~/.vim/bundle/ctrlp.vim3
" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.sass-cache$|\.hg$\|\.svn$\|\.yardoc\|public$|log\|tmp$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Display extra whitespace
set list listchars=tab:»·,trail:·

" backup dir
set backupdir=~/.tmp//,/tmp//
set directory=~/.tmp//,/tmp//
let g:netrw_list_hide= '.*\.swp$'
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}

"for tabularize
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

nmap ,cs :let @+=expand("%")<CR>
nmap ,cl :let @+=expand("%:p")<CR>

nnoremap <leader><space> :noh<cr>

" vim-rspec mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
let g:rspec_command = "Dispatch bundle exec rspec {spec}"

" netrw sytling
let g:netrw_liststyle=3

