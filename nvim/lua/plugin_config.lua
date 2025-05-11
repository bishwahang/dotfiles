-- FZF config
vim.g.fzf_preview_window = { "right:50%:hidden", "ctrl-/" }
vim.cmd([[
  command! -nargs=* Ag call fzf#vim#ag(<q-args>, '--hidden --vimgrep', fzf#vim#with_preview(), <bang>0)
]])

-- vim-test config
vim.g["test#strategy"] = "neovim"
vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"

-- ALE settings
vim.g.ale_lint_on_text_changed = "never"
vim.g.ale_lint_on_enter = 0
vim.g.ale_lint_on_insert_leave = 0
vim.g.ale_lint_on_save = 1

