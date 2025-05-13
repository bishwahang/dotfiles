-- Leader key
vim.g.mapleader = ","

-- Load core config
require("options")
require("keybindings")
require("autocmds")

-- Lazy.nvim plugin manager bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("plugins")
require("plugin_config")
