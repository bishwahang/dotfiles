-- FZF/RipGrep configuration
vim.cmd([[
  " RgSearch command: RgSearch [flags] pattern [path]
  command! -nargs=+ -complete=dir RgSearch call s:RgSearch(<f-args>)

  function! s:RgSearch(...)
    if a:0 < 1
      echo "Usage: RgSearch [flags] pattern [path]"
      return
    endif

    " Collect all arguments
    let l:args = copy(a:000)
    let l:flags = []
    let l:pattern = ""
    let l:path = ""

    " First, extract all flags (arguments starting with -)
    let l:i = 0
    while l:i < len(l:args)
      if l:args[l:i] =~# '^-'
        call add(l:flags, l:args[l:i])
        call remove(l:args, l:i)
      else
        let l:i += 1
      endif
    endwhile

    " After removing flags, first remaining arg is pattern, second (if exists) is path
    if len(l:args) > 0
      let l:pattern = l:args[0]

      if len(l:args) > 1
        let l:path = l:args[1]
      endif
    else
      echo "No search pattern provided"
      return
    endif

    " Join flags
    let l:flag_str = join(l:flags, ' ')

    " Build command with correct handling of -e flag
    let l:cmd = 'rg --column --line-number --no-heading --color=always --smart-case '

    " Check if -e flag is present and handle pattern appropriately
    if l:flag_str =~# '-e\>'
      " If -e flag is present, don't use -- separator
      let l:cmd .= l:flag_str . ' ' . shellescape(l:pattern)
    else
      " Otherwise, use -- separator
      let l:cmd .= l:flag_str . ' -- ' . shellescape(l:pattern)
    endif

    " Add path if provided
    if l:path != ''
      let l:cmd .= ' ' . shellescape(l:path)
    endif

    call fzf#vim#grep(l:cmd, 1, fzf#vim#with_preview())
  endfunction
]])

-- Set split directions
vim.opt.splitright = true

-- Preview
vim.g.fzf_preview_window = { "right:50%:hidden", "ctrl-/" }
