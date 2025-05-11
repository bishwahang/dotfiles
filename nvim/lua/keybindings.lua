local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- FZF: Ctrl-P to search files
map("n", "<C-p>", ":Files<CR>", opts)

-- SilverSearcher
map("n", "<Leader>ag", ":Ag<Space>", opts)

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


-- LuaSnip snippets

-- local ls = require("luasnip")
--
-- map({ "i", "s" }, "<Tab>", function()
--     return ls.expand_or_jumpable() and "<Plug>luasnip-expand-or-jump" or "<Tab>"
-- end, { expr = true, silent = true })
--
-- map({ "i", "s" }, "<S-Tab>", function()
--     return ls.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<S-Tab>"
-- end, { expr = true, silent = true })
--
