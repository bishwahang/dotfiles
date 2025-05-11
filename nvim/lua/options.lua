-- Movement and editing
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.hidden = true
vim.opt.wrap = false
vim.opt.scrolloff = 3
vim.opt.mouse = "a"
vim.opt.updatetime = 300
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.laststatus = 2
vim.opt.title = true
vim.opt.list = true
vim.opt.listchars = { tab = "»·", trail = "·" }

-- Enable statusline
vim.opt.laststatus = 2
vim.opt.laststatus = 2

vim.opt.statusline = table.concat({
  " %f", -- full file path
  " [%{strlen(&ft) ? &ft : 'none'},%{&fileformat}]", -- filetype + format
  " %h%1*%m%r%w%0*", -- help, modified, readonly, preview
  " %{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}", -- git branch
  " %=", -- align right
  "%-14.(%l,%c%V%) %<%P", -- line/column, truncate long paths, file percent
})

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.syntax = "on"

-- Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileformats = { "unix", "dos", "mac" }

-- Undo & swap (Neovim-specific paths)
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.opt.directory = vim.fn.stdpath("data") .. "/swap"

-- Create those directories if missing
vim.fn.mkdir(vim.opt.undodir:get()[1], "p")
vim.fn.mkdir(vim.opt.backupdir:get()[1], "p")
vim.fn.mkdir(vim.opt.directory:get()[1], "p")

-- Modelines
vim.opt.modeline = true
vim.opt.modelines = 10

-- colors
vim.opt.termguicolors = true

-- Enable system clipboard if available
if vim.fn.has("unnamedplus") == 1 then
  vim.opt.clipboard = { "unnamed", "unnamedplus" }
end

