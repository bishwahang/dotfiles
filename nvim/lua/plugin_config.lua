-- FZF config
require("plugin_config.fzf")
-- vim-test config
vim.g["test#strategy"] = "dispatch"

-- ALE settings
vim.g.ale_lint_on_text_changed = "never"
vim.g.ale_lint_on_enter = 0
vim.g.ale_lint_on_insert_leave = 0
vim.g.ale_lint_on_save = 1

vim.g.ale_linters = {
    ruby = {'rubocop'},
}
vim.g.ale_fixers = {
    ruby = {'rubocop'},
}
vim.g.ale_fix_on_save = 1


-- UltiSnip
vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'

require("plugin_config.colorscheme")
