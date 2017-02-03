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
source ~/.dotfiles/bundles.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Wrap text instead of being on one line
set lbr
" no bell or blink on error
set noerrorbells visualbell t_vb=
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
set showcmd            " Show (partial) command in status line.
set cursorline " highlight current line
set showmatch          " Show matching brackets.
" Turn on line numbering. Turn it off with "set nonu"
set number
set relativenumber
set splitbelow
set splitright
set numberwidth=5
set ignorecase          " Do case insensitive matching
set hlsearch            " Higlhight search
set smartcase           " Do smart case matching
set incsearch           " Incremental search
"set autowrite          " Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a             " Enable mouse usage (all modes)
set noswapfile
" Display extra whitespace
set list listchars=tab:»·,trail:·
" Save our undo changes.
set undodir=~/.undo
set undofile " maintains undo history between sessions
" backup dir
set backupdir=~/.tmp//,/tmp//
set directory=~/.tmp//,/tmp//
set spelllang=en_us
" Set the Vim command history size to a larger number.
set history=9999
set undolevels=9999
" colorscheme
colorscheme solarized
" let g:solarized_termcolors=256
set term=xterm-256color
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

" Change <Leader>
let mapleader = ","
let g:browser = 'open '

" Nice statusbar
set laststatus=2
set statusline=\ "
set statusline+=%f\ " file name
set statusline+=[
set statusline+=%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&fileformat}] " file format
set statusline+=%h%1*%m%r%w%0* " flag
set statusline+=%= " right align
set statusline+=%-14.(%l,%c%V%)\ %<%P " offset
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}

" set tabstop=2 softtabstop=2 shiftwidth=2
set smarttab expandtab
" Enable tab complete for commands.
" first tab shows all matches. next tab starts cycling through the matches
set wildmenu
set wildmode=list:longest,full

" Using 'smartindent' is obsolete; let ftindent plugins do their magic and
" just format C-like files.
set cindent

" Make backspace work in insert mode
set backspace=indent,eol,start

" enable setting title
set title
" configure title to look like: Vim /path/to/file
set titlestring=VIM:\ %-25.55F\ %a%r%m titlelen=70


" Ignore a lot of stuff.
set wildignore+=*.swp,*.so,*.zip,*.pyc,*.bak,*.class,*.orig
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.svg
set wildignore+=build/*,tmp/*,vendor/cache/*,bin/*
set wildignore+=.sass-cache/*
set wildignore+=node_modules/*,bower_components/*

" Ctlr-P {{{2
let g:ctrlp_jump_to_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'find %s -type f'

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
 au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Filetype tabs
augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml set autoindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab
  autocmd FileType python set autoindent shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType javascript,html,htmldjango,css set autoindent shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType vim set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType cucumber set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType puppet set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType cpp set autoindent ts=4 sts=4 sw=4 expandtab
  autocmd FileType c set autoindent ts=4 sts=4 sw=4 expandtab

  au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
  au BufRead,BufNewFile *etc/nginx/* set ft=nginx 
  " treat rackup files like ruby
  au BufRead,BufNewFile *.ru set ft=ruby
  au BufRead,BufNewFile Gemfile set ft=ruby
  autocmd BufEnter *.haml setlocal cursorcolumn
  au BufRead,BufNewFile Gemfile set ft=ruby
  au BufRead,BufNewFile Capfile set ft=ruby
  au BufRead,BufNewFile Thorfile set ft=ruby
  au BufRead,BufNewFile *.god set ft=ruby
  au BufRead,BufNewFile .caprc set ft=ruby
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" neo complete
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" Turn on language specific omnifuncs
" python
autocmd FileType python set omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
""" end neo complete

" ALE
" show Vim windows for the loclist or quickfix items when a file contains warnings or errors
let g:ale_open_list = 1
" disable lint while typing
let g:ale_lint_on_text_changed = 'never'
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 0
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Enable omni completion.
autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" python set to jedi vim
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
"Ruby autocomplete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" spelling
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd BufRead,BufNewFile *.markdown setlocal spell
set complete+=kspell
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

" Section: functions

function! s:RunShellCommand(cmdline)
  botright new

  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal nobuflisted
  setlocal noswapfile
  setlocal nowrap
  setlocal filetype=shell
  setlocal syntax=shell

  call setline(1,a:cmdline)
  call setline(2,substitute(a:cmdline,'.','=','g'))
  execute 'silent $read !'.escape(a:cmdline,'%#')
  setlocal nomodifiable
  1
endfunction

" Open the Rails ApiDock page for the word under cursor, using the 'open'
" command
function! OpenRailsDoc(keyword)
  let url = 'http://apidock.com/rails/'.a:keyword
  exec '!'.g:browser.' '.url
endfunction

" Open the Ruby ApiDock page for the word under cursor, using the 'open'
" command
function! OpenRubyDoc(keyword)
  let url = 'http://apidock.com/ruby/'.a:keyword
  exec '!'.g:browser.' '.url
endfunction
" Shell
command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
"""
" MAPPINGS
"""
" ----------------------------------------------------------------------------
" Buffers
" ----------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" ----------------------------------------------------------------------------
" Tabs
" ----------------------------------------------------------------------------
nnoremap <leader>tn :tabn<cr>
nnoremap <leader>tp :tabp<cr>
nnoremap <leader>te :tabedit

" ----------------------------------------------------------------------------
" <tab> / <s-tab> | Circular windows navigation
" ----------------------------------------------------------------------------
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" Remap F1 from Help to ESC.  No more accidents.
nmap <F1> <Esc>
map! <F1> <Esc>
" bind KK to grep word under cursor
nnoremap KK :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" bind \ (backward slash) to grep shortcut
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" create tags
map <Leader>ct :!ctags -R --exclude=.bundle --exclude=.git .<CR>
set tags=./tags,tags

" search next/previous -- center in page
let g:indexed_search_unfold=1
let g:indexed_search_center=1

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
" qq to record, Q to replay
nnoremap Q @q
" nnoremap <expr> gp `[v`]
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]''`]`'
nnoremap <expr> gb '`[' . getregtype()[0] . '`]''`]`'

" for tabularize
" Mappings for ruby hash rocket and symbol hashes
nnoremap <silent> <Leader>ahs :Tabularize /\s\?\w\+:[^:]/l0l0<CR>
vnoremap <silent> <Leader>ahs :Tabularize /\s\?\w\+:[^:]/l0l0<CR>
nnoremap <silent> <Leader>ahr  :Tabularize  /^[^=]*\zs=><CR>
vnoremap <silent> <Leader>ahr  :Tabularize  /^[^=]*\zs=><CR>
" normal equals and json
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

" copy current file path
nmap <Leader>cs :let @+=expand("%")<CR>
nmap <Leader>cl :let @+=expand("%:p")<CR>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

nnoremap <Leader><space> :noh<cr>
" Easily lookup documentation on apidock
noremap <leader>rb :call OpenRubyDoc(expand('<cword>'))<CR><CR>
noremap <leader>rr :call OpenRailsDoc(expand('<cword>'))<CR><CR>

" vim-rspec mappings
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
" make test commands execute using dispatch.vim
let test#strategy = "dispatch"

" netrw sytling
let g:netrw_liststyle=3
let g:netrw_list_hide= '.*\.swp$'

" vimtex output
let g:vimtex_latexmk_build_dir="build"

" Snippets
" Some variables need default value
if !exists("g:snips_author")
    let g:snips_author = "Bishwa Hang Rai"
endif

if !exists("g:snips_email")
    let g:snips_email = "bishwahang.kirat@gmail.com"
endif

if !exists("g:snips_github")
    let g:snips_github = "https://github.com/bishwahang"
endif

map <C-n> :NERDTreeToggle<CR>
" sudo save
cmap w!! w !sudo tee > /dev/null %

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

augroup vimrc
  au InsertLeave * silent! set nopaste
augroup END

" Go
" format with goimports instead of gofmt
let g:go_fmt_command = "goimports"

" set t_te= t_ti=
" au VimLeave * :!clear
" autocmd filetype crontab setlocal nobackup nowritebackup
let $BASH_ENV= "~/.bash_aliases"

if filereadable('.local.vim')
  so .local.vim
endif
