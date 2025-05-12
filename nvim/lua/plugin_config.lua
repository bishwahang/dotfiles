-- FZF config
require("plugin_config.fzf")
-- vim-test config
vim.g["test#strategy"] = "dispatch"

-- ALE settings
vim.g.ale_lint_on_text_changed = "never"
vim.g.ale_lint_on_enter = 0
vim.g.ale_lint_on_insert_leave = 0
vim.g.ale_lint_on_save = 1

-- Linters configuration
vim.g.ale_linters = {
    ruby = {'ruby', 'rubocop'},
}

-- Fixers configuration
vim.g.ale_fixers = {
    -- Apply specific fixers for Ruby
    ruby = {'rubocop', 'trim_whitespace', 'remove_trailing_lines'},

    -- Apply generic fixers to all files
    ['*'] = {'trim_whitespace', 'remove_trailing_lines'},
}

-- Enable fixing on save
vim.g.ale_fix_on_save = 1

-- Rubocop specific options - use auto-correct
vim.g.ale_ruby_rubocop_executable = 'bundle'  -- Use bundled version if available
vim.g.ale_ruby_rubocop_options = '--auto-correct'

-- Show fixing details
vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'

-- Optional: show the total number of warnings/errors in the statusline
vim.g.ale_statusline_format = {'E:%d', 'W:%d', ''}


-- UltiSnip
vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'

