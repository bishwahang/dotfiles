local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- FZF: Ctrl-P to search files
map("n", "<C-p>", ":Files<CR>", opts)

-- FZF Preview toggle (default: Ctrl-/)
vim.g.fzf_preview_window = { "right:50%:hidden", "ctrl-/" }

-- Git status with Fugitive
map("n", "<Leader>gs", ":G<CR>", opts)

-- AG search (requires silversearcher-ag installed)
vim.cmd([[
  command! -nargs=* Ag call fzf#vim#ag(<q-args>, '--hidden --vimgrep', fzf#vim#with_preview(), <bang>0)
]])
map("n", "<Leader>ag", ":Ag<Space>", opts)

-- vim-test config
vim.g["test#strategy"] = "neovim"
vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"

