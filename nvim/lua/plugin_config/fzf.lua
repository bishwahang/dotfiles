-- FZF/RipGrep configuration
vim.cmd([[
  " RgSearch command: RgSearch [flags] pattern [path]
  command! -nargs=+ -complete=dir RgSearch call s:RgSearch(<f-args>)

  function! s:RgSearch(...)
    if a:0 < 1
      echo "Usage: RgSearch [flags] pattern [path]"
      return
    endif

    " Start building the base command
    let l:cmd = 'rg --column --line-number --no-heading --color=always --smart-case '

    " Special handling for quoted patterns (to support multi-word search)
    let l:args = copy(a:000)
    let l:i = 0
    let l:quoted_pattern = ""
    let l:quote_found = 0

    " Check if any argument is quoted
    while l:i < len(l:args)
      let l:arg = l:args[l:i]
      " Check for starting quote
      if l:arg =~ "^['\"]" && !l:quote_found
        let l:quote_start_idx = l:i
        let l:quote_found = 1

        " Check if quote ends in the same argument
        if l:arg =~ "['\"]$"
          " Single-argument quote
          let l:quoted_pattern = l:arg[1:-2]  " Remove quotes
          call remove(l:args, l:i)
          break
        endif
      " Check for ending quote if we've found a starting quote
      elseif l:arg =~ "['\"]$" && l:quote_found
        let l:quote_end_idx = l:i

        " Extract and join all arguments between start and end
        let l:quote_parts = l:args[l:quote_start_idx : l:quote_end_idx]

        " Remove quotes from first and last parts
        let l:quote_parts[0] = l:quote_parts[0][1:]
        let l:quote_parts[-1] = l:quote_parts[-1][:-2]

        " Join the parts
        let l:quoted_pattern = join(l:quote_parts, ' ')

        " Remove these arguments from the args list
        for l:j in range(l:quote_end_idx, l:quote_start_idx, -1)
          call remove(l:args, l:j)
        endfor

        break
      endif
      let l:i += 1
    endwhile

    " Extract flags
    let l:flags = []
    let l:has_e_flag = 0
    let l:pattern = ""
    let l:path = ""

    let l:i = 0
    while l:i < len(l:args)
      if l:args[l:i][0] == '-'
        call add(l:flags, l:args[l:i])
        if l:args[l:i] == '-e'
          let l:has_e_flag = 1
        endif
        call remove(l:args, l:i)
      else
        let l:i += 1
      endif
    endwhile

    " If we have a quoted pattern, use it; otherwise process args normally
    if l:quoted_pattern != ""
      let l:pattern = l:quoted_pattern
      " Add -F flag for multi-word searches if not already specified
      if !index(l:flags, '-F') != -1 && l:pattern =~ ' '
        call add(l:flags, '-F')
      endif

      " Check if there's a path argument left
      if len(l:args) > 0
        let l:path = l:args[0]
      endif
    else
      " Normal processing - first arg is pattern, second (if any) is path
      if len(l:args) > 0
        let l:pattern = l:args[0]

        if len(l:args) > 1
          let l:path = l:args[1]
        endif
      else
        echo "No search pattern provided"
        return
      endif
    endif

    " Join flags
    let l:flag_str = join(l:flags, ' ')

    " Build final command
    if l:has_e_flag
      " If -e flag is present, don't use -- separator
      let l:cmd .= l:flag_str . ' ' . shellescape(l:pattern)
    else
      " Otherwise, use -- separator
      let l:cmd .= l:flag_str . ' -- ' . shellescape(l:pattern)
    endif

    " Add path if provided
    if exists('l:path') && l:path != ''
      let l:cmd .= ' ' . shellescape(l:path)
    endif

    " Debug line - uncomment if needed
    " echom "Running command: " . l:cmd

    call fzf#vim#grep(l:cmd, 1, fzf#vim#with_preview())
  endfunction
]])
-- Set split directions
vim.opt.splitright = true

-- Preview
vim.g.fzf_preview_window = { "right:50%:hidden", "ctrl-/" }
