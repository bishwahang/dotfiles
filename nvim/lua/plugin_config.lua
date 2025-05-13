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

-- Colorscheme configuration
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd[[colorscheme solarized]]

-- Nvim-surround configuration
require("nvim-surround").setup({})

-- Configure completions to show menu even for single suggestions
vim.o.completeopt = 'menu,menuone'

-- Nvim-cmp configuration
local cmp = require("cmp")
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })  -- << this expands the currently selected item
            elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<CR>"), "")
            elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                vim.fn.feedkeys(t("<C-R>=UltiSnips#JumpForwards()<CR>"), "")
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                vim.fn.feedkeys(t("<C-R>=UltiSnips#JumpBackwards()<CR>"), "")
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "ultisnips" },
        -- { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    },
    matching = {
        disallow_fuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_prefix_unmatching = true,
    },
})

-- Gitlab setup
require('gitlab').setup({
  statusline = {
    enabled = false
  },
  code_suggestions = {
    -- Configure filetypes where code suggestions should be active
    auto_filetypes = { 'ruby', 'javascript', 'python', 'go' }, -- Adjust as needed
    ghost_text = {
      enabled = false, -- Set to true if you want to enable ghost text feature
      toggle_enabled = "<C-h>",
      accept_suggestion = "<C-l>",
      clear_suggestions = "<C-k>",
      stream = true,
    },
  },
  minimal_message_level = vim.log.levels.ERROR
})
