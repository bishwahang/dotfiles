let g:polyglot_disabled = []

source ~/.dotfiles/bundles.vim

"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
set nocompatible
filetype plugin indent on

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary
set ttyfast

" " Display extra whitespace
" set list listchars=tab:»·,trail:·

" Enable mouse usage (all modes)
set mouse=a

" Save our undo changes.
set undodir=~/.undo
set undofile " maintains undo history between sessions

" backup dir
set backupdir=~/.tmp//,/tmp//
set directory=~/.tmp//,/tmp//
set spelllang=en_us

set showcmd " Show (partial) command in status line.
set cursorline " highlight current line
set showmatch " Show matching brackets.

set relativenumber
set splitbelow
set splitright
set numberwidth=5

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Map leader to ,
let mapleader=','
let g:browser = 'open '

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Directories for swp files
set nobackup
set noswapfile

set fileformats=unix,dos,mac

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number

" let no_buffers_menu=1
if !exists('g:not_finish_vimplug')
    colorscheme solarized
endif

if has('gui_running')
  set background=light
  set lines=999 columns=999
else
  set background=dark
endif

set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  " IndentLine
  " let g:indentLine_enabled = 1
  " let g:indentLine_concealcursor = 0
  " let g:indentLine_char = '┆'
  " let g:indentLine_faster = 1

  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm'
      set term=xterm-256color
    endif
  endif
endif


if &term =~ '256color'
  set t_ut=
endif


"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

" set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" if exists("*fugitive#statusline")
"   set statusline+=%{fugitive#statusline()}
" endif

" vim-airline
" let g:airline_theme = 'powerlineish'
" let g:airline#extensions#syntastic#enabled = 1
" let g:airline#extensions#branch#enabled = 1
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tagbar#enabled = 1
" let g:airline_skip_empty_sections = 1

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

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

"" NERDTree configuration
" let g:NERDTreeChDirMode=2
" let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
" let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
" let g:NERDTreeShowBookmarks=1
" let g:nerdtree_tabs_focus_on_files=1
" let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
" let g:NERDTreeWinSize = 50
" Ignore a lot of stuff.
" nnoremap <silent> <F2> :NERDTreeFind<CR>
" noremap <F3> :NERDTreeToggle<CR>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.bak,*.class,*.orig,*.db,*.sqlite
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.svg
set wildignore+=build/*,tmp/*,vendor/cache/*,bin/*
set wildignore+=.sass-cache/*
set wildignore+=node_modules/*,bower_components/*

" sudo save
cmap w!! w !sudo tee > /dev/null %

" grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules'

" vimshell.vim
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_prompt =  '$ '

nnoremap <silent> <leader>sh :VimShellCreate<CR>

"*****************************************************************************
"" Functions
"*****************************************************************************
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif

" related to ruby/rails doc
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
  let url = 'http://api.rubyonrails.org/?q='.a:keyword
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

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
" augroup vimrc-sync-fromstart
"   autocmd!
"   autocmd BufEnter * :syntax sync maxlines=200
" augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" fugitive
augroup fugitive
  "" fugitive clear buffer after visiting git object
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

augroup vimrc
  au InsertLeave * silent! set nopaste
augroup END


" spelling
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd BufRead,BufNewFile *.markdown setlocal spell
set complete+=kspell

set autoread

"*****************************************************************************
"" Mappings
"*****************************************************************************

"" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"" Git
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Git<CR>
noremap <Leader>gb :Git blame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

" session management
nnoremap <leader>so :OpenSession<Space>
nnoremap <leader>ss :SaveSession<Space>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>

"" circular navigation
" nnoremap <tab>   <c-w>w
" nnoremap <S-tab> <c-w>W

" tabs
" nnoremap <leader>te :tabedit

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__

"" fzf.vim
" See `man fzf-tmux` for available options
" TODO: research more about this
" if exists('$TMUX')
"   let g:fzf_layout = { 'tmux': '-p90%,60%' }
" else
"   let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" endif

let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
  let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']
  " See here: https://github.com/junegunn/fzf.vim/issues/27#issuecomment-608294881
  " command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '', fzf#vim#with_preview(), <bang>0)
  " "Raw" version of ag; arguments directly passed to ag
  "
  " e.g.
  "   " Search 'foo bar' in ~/projects
  "   :Ag "foo bar" ~/projects
  "
  "   " Start in fullscreen mode
  "   :Ag! "foo bar"
  "   Raw version without preview
  " command! -bang -nargs=+ -complete=file Ag call fzf#vim#ag_raw(<q-args>, <bang>0)

  " Raw version with preview
  command! -bang -nargs=+ -complete=file Ag call fzf#vim#ag_raw(<q-args>, fzf#vim#with_preview(), <bang>0)


  " AgIn: Start ag in the specified directory
  "
  " e.g.
  "   :AgIn .. foo
  function! s:ag_in(bang, ...)
      if !isdirectory(a:1)
          throw 'not a valid directory: ' .. a:1
      endif
      " Press `ctrl-/' to enable preview window.
      call fzf#vim#ag(join(a:000[1:], ' '), fzf#vim#with_preview({'dir': a:1}, 'right:50%:hidden', 'ctrl-/'), a:bang)

      " If you don't want preview option, use this
      " call fzf#vim#ag(join(a:000[1:], ' '), {'dir': a:1}, a:bang)
  endfunction

  command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>)

  " bind \ (backward slash) to grep shortcut
  nnoremap \ :Ag<SPACE>

  " find word under cursor
  nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
endif

" " ripgrep
" if executable('rg')
"   let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
"   set grepprg=rg\ --vimgrep
"   command! -bang -nargs=* RG call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
" endif

" command! -bang -nargs=? -complete=dir Files
"     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--info=inline']}), <bang>0)
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <C-p> :FZF -m<CR>

" Snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-tab>"
let g:UltiSnipsEditSplit="vertical"

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

" syntastic
" let g:syntastic_always_populate_loc_list=1
" let g:syntastic_auto_loc_list=1
" let g:syntastic_aggregate_errors = 1
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
" let syntastic_mode_map = { 'passive_filetypes': ['yaml'] }

" let g:syntastic_python_checkers=['python', 'flake8']

" let g:syntastic_go_checkers = ['golint', 'govet']
" let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

" let g:syntastic_error_symbol='✗'
" let g:syntastic_warning_symbol='⚠'
" let g:syntastic_style_error_symbol = '✗'
" let g:syntastic_style_warning_symbol = '⚠'




" ale
" show Vim windows for the loclist or quickfix items when a file contains warnings or errors
" let g:ale_open_list = 1
" disable lint while typing
let g:ale_lint_on_text_changed = 'never'
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 0
let g:ale_lint_on_insert_leave = 0
" enable when saving file
let g:ale_lint_on_save = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>q :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>w :bn<CR>

"" Close buffer
noremap <leader>c :bd<CR>

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"" Open current line on GitHub
nnoremap <Leader>o :.Gbrowse<CR>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
" qq to record, Q to replay
nnoremap Q @q

" Remap F1 from Help to ESC.  No more accidents.
nmap <F1> <Esc>
map! <F1> <Esc>


" create tags
map <Leader>ct :!ctags -R --exclude=.bundle --exclude=.git .<CR>
set tags=./tags,tags

" search next/previous -- center in page
let g:indexed_search_unfold=1
let g:indexed_search_center=1

" copy current file path
nmap <Leader>cs :let @+=expand("%")<CR>
nmap <Leader>cl :let @+=expand("%:p")<CR>
"*****************************************************************************
"" Custom configs
"*****************************************************************************

" c
autocmd FileType c setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 expandtab


" go
" vim-go
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

augroup completion_preview_close
  autocmd!
  if v:version > 703 || v:version == 703 && has('patch598')
    autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
  endif
augroup END

augroup go

  au!
  au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  au FileType go nmap <Leader>dd <Plug>(go-def-vertical)
  au FileType go nmap <Leader>dv <Plug>(go-doc-vertical)
  au FileType go nmap <Leader>db <Plug>(go-doc-browser)

  au FileType go nmap <leader>r  <Plug>(go-run)
  au FileType go nmap <leader>t  <Plug>(go-test)
  au FileType go nmap <Leader>gt <Plug>(go-coverage-toggle)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go nmap <silent> <Leader>L <Plug>(go-metalinter)
  au FileType go nmap <C-g> :GoDecls<cr>
  au FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
  au FileType go nmap <leader>gb :<C-u>call <SID>build_go_files()<CR>

augroup END


" html
" for html files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab


" javascript
let g:javascript_enable_domhtmlcss = 1

" vim-javascript
augroup vimrc-javascript
  autocmd!
  autocmd FileType javascript set tabstop=4|set shiftwidth=4|set expandtab softtabstop=4
augroup END


" python
" vim-python
augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "0"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#smart_auto_mappings = 0

" Syntax highlight
" Default highlight is better than polyglot
let g:polyglot_disabled = ['python']
let python_highlight_all = 1

" using vim-tex
let g:polyglot_disabled = ['latex']



" ruby
augroup vimrc-ruby
  autocmd!
  autocmd BufNewFile,BufRead *.rb,*.rbw,*.gemspec setlocal filetype=ruby
  autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
  " Easily lookup documentation on apidock
  autocmd FileType ruby noremap <leader>rb :call OpenRubyDoc(expand('<cword>'))<CR><CR>
  autocmd FileType ruby noremap <leader>rr :call OpenRailsDoc(expand('<cword>'))<CR><CR>

  " Mappings for ruby hash rocket and symbol hashes
  autocmd FileType ruby nnoremap <silent> <Leader>ahs :Tabularize /\s\?\w\+:[^:]/l0l0<CR>
  autocmd FileType ruby vnoremap <silent> <Leader>ahs :Tabularize /\s\?\w\+:[^:]/l0l0<CR>
  autocmd FileType ruby nnoremap <silent> <Leader>ahr  :Tabularize  /^[^=]*\zs=><CR>
  autocmd FileType ruby vnoremap <silent> <Leader>ahr  :Tabularize  /^[^=]*\zs=><CR>

  " " Ruby refactory (not used frequently)
  " autocmd FileType ruby nnoremap <leader>rap  :RAddParameter<cr>
  " autocmd FileType ruby nnoremap <leader>rcpc :RConvertPostConditional<cr>
  " autocmd FileType ruby nnoremap <leader>rel  :RExtractLet<cr>
  " autocmd FileType ruby vnoremap <leader>rec  :RExtractConstant<cr>
  " autocmd FileType ruby vnoremap <leader>relv :RExtractLocalVariable<cr>
  " autocmd FileType ruby nnoremap <leader>rit  :RInlineTemp<cr>
  " autocmd FileType ruby vnoremap <leader>rlv  :RRenameLocalVariable<cr>
  " autocmd FileType ruby vnoremap <leader>riv  :RRenameInstanceVariable<cr>
  " autocmd FileType ruby vnoremap <leader>rem  :RExtractMethod<cr>
augroup END

let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'd:describes',
        \ 'C:contexts',
        \ 'f:methods',
        \ 'F:singleton methods'
    \ ]
\ }

" for tabularize
" normal equals and json
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

" vim-test mappings
nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>s :TestNearest<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>g :TestVisit<CR>


let test#strategy = "dispatch"
" let test#ruby#rspec#executable = 'bundle exec rspec'

" vimtex output
let g:vimtex_latexmk_build_dir="build"

let g:deoplete#enable_at_startup = 1

" neo complete
" Disable AutoComplPop.
" let g:acp_enableAtStartup = 0
" " Use neocomplete.
" let g:neocomplete#enable_at_startup = 1
" " Use smartcase.
" let g:neocomplete#enable_smart_case = 1
" " Set minimum syntax keyword length.
" let g:ueocomplete#sources#syntax#min_keyword_length = 3
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" " Enable snipMate compatibility feature.
" let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
" let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/UltiSnips'

" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><C-y>  neocomplete#close_popup()
" inoremap <expr><C-e>  neocomplete#cancel_popup()

" Turn on language specific omnifuncs
" python
autocmd FileType python set omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
" if !exists('g:neocomplete#force_omni_input_patterns')
"         let g:neocomplete#force_omni_input_patterns = {}
" endif
" let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
""" end neo complete

"*****************************************************************************
"*****************************************************************************

" netrw sytling
let g:netrw_banner    = 0
let g:netrw_liststyle = 3
let g:netrw_winsize   = 25
let g:netrw_preview   = 1
let g:netrw_altv      = 1
let g:netrw_keepdir = 0

"" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
" to make bash_alises work inside vim
let $BASH_ENV= "~/.bash_aliases"

"*****************************************************************************
"" Convenience variables
"*****************************************************************************
" FSharp Testing
" let g:fsharpbinding_debug = 1
" let g:fsharp_interactive_bin = '/Library/Frameworks/Mono.framework/Versions/Current/Commands/fsharpi'
" let g:fsharp_xbuild_path = "/Library/Frameworks/Mono.framework/Versions/Current/Commands/msbuild"
"
" " save folds
" augroup remember_folds
"   autocmd!
"   autocmd BufWinLeave * mkview
"   autocmd BufWinEnter * silent! loadview
" augroup END
" set viewoptions-=curdir

" prettify json file
nmap <silent> <leader>pj :%!python -m json.tool<CR>


" faith/vim-go tutorial
set autowrite
map <leader>cn :cnext<CR>
map <leader>cp :cprevious<CR>
nnoremap <leader>cc :cclose<CR>
highlight Comment cterm=italic
