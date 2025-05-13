local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- FZF:
-- Ctrl-P to search files
map("n", "<C-p>", ":Files<CR>", opts)
-- Buffers
map("n", "<Leader>b", ":Buffers<CR>", opts)

-- RipGrep
-- Basic search (backslash key)
vim.keymap.set('n', '\\', ':RgSearch ', { noremap = true })

-- Search for word under cursor (normal search)
vim.keymap.set('n', '<leader>rg', function()
  local word = vim.fn.expand('<cword>')
  vim.cmd('RgSearch ' .. word)
end, { noremap = true, silent = true })

-- Search for word under cursor with word boundaries (whole word only)
vim.keymap.set('n', '<leader>rw', function()
  local word = vim.fn.expand('<cword>')
  vim.cmd('RgSearch -e \\b' .. word .. '\\b')
end, { noremap = true, silent = true })

-- Git commands via vim-fugitive
map("n", "<Leader>gs", ":Git<CR>", opts)
map("n", "<Leader>ga", ":Gwrite<CR>", opts)
map("n", "<Leader>gc", ":Gcommit<CR>", opts)
map("n", "<Leader>gsh", ":Gpush<CR>", opts)
map("n", "<Leader>gll", ":Gpull<CR>", opts)
map("n", "<Leader>gb", ":Git blame<CR>", opts)
map("n", "<Leader>gd", ":Gvdiff<CR>", opts)
map("n", "<Leader>gr", ":Gremove<CR>", opts)
map("n", "<Leader>o", ":.GBrowse<CR>", opts)

-- Yank to end of line
map("n", "Y", "y$", { noremap = true })

-- Normal mode mappings
map("n", "YY", '"+y', { noremap = true, silent = true })
map("n", "XX", '"+x', { noremap = true, silent = true })
map("n", "<Leader>p", '"+gP', { noremap = true, silent = true })

-- macOS-only visual mode mappings for pbcopy
if vim.fn.has("macunix") == 1 then
    map("v", "<C-x>", ':!pbcopy<CR>', { noremap = true, silent = true })
    map("v", "<C-c>", ':w !pbcopy<CR><CR>', { noremap = true, silent = true })
end

-- Better search movement (center screen on match)
map("n", "n", "nzzzv", { noremap = true })
map("n", "N", "Nzzzv", { noremap = true })

-- Smart vertical movement (gj/gk unless count provided)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, noremap = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, noremap = true })

-- Command-line abbreviations
vim.cmd [[
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
]]

-- Write with sudo (w!!)
vim.cmd [[
cmap w!! w !sudo tee > /dev/null %
]]

-- Window navigation
map("n", "<C-j>", "<C-w>j", { noremap = true })
map("n", "<C-k>", "<C-w>k", { noremap = true })
map("n", "<C-h>", "<C-w>h", { noremap = true })
map("n", "<C-l>", "<C-w>l", { noremap = true })

-- Readline-style keybindings in Neovim command-line mode
vim.api.nvim_set_keymap('c', '<C-a>', '<Home>', {noremap = true})
vim.api.nvim_set_keymap('c', '<C-e>', '<End>', {noremap = true})
vim.api.nvim_set_keymap('c', '<A-b>', '<S-Left>', {noremap = true})
vim.api.nvim_set_keymap('c', '<A-f>', '<S-Right>', {noremap = true})
vim.api.nvim_set_keymap('c', '<C-k>', '<C-\\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>', {noremap = true})
vim.api.nvim_set_keymap('c', '<A-BS>', '<C-W>', {noremap = true})


-- Keep visual selection when shifting
map("v", "<", "<gv", { noremap = true })
map("v", ">", ">gv", { noremap = true })

-- Move visual block up/down
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })

-- Clear search highlight
map("n", "<Leader><Space>", ":noh<CR>", { noremap = true, silent = true })

-- Copy file path to clipboard
map("n", "<Leader>cs", ':let @+ = expand("%")<CR>', { noremap = true, silent = true })
map("n", "<Leader>cl", ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true })

-- Open tab in current directory
map("n", "<Leader>te", ":tabe <C-R>=expand('%:p:h') . '/'<CR>", { noremap = true })

-- Map F1 to Esc
map("n", "<F1>", "<Esc>")
map("i", "<F1>", "<Esc>")

-- pretify json
map("n", "<Leader>pj", ":%!python3 -m json.tool<CR>", opts)


-- Ale
map("n", "<C-j>", "<Plug>(ale_next_wrap)", {})
map("n", "<C-k>", "<Plug>(ale_previous_wrap)", {})

-- VimTest
-- Run the current file’s tests
map("n", "<leader>t", ":TestFile<CR>", opts)
--- Run the test nearest to the cursor
map("n", "<leader>s", ":TestNearest<CR>", opts)
-- Run the full suite
map("n", "<leader>l", ":TestLast<CR>", opts)

-- Gitlab
vim.keymap.set('n', '<C-g>', '<Plug>(GitLabToggleCodeSuggestions)')
