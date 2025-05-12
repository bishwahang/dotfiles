require("lazy").setup({
    {
        "Tsuzat/NeoSolarized.nvim",
        priority = 1000,
        config = function()
            require('NeoSolarized').setup({
                style = "dark", -- "dark" or "light"
                transparent = false, -- Enable/disable transparency
                terminal_colors = true, -- Configure terminal colors
                enable_italics = true, -- Italics for different parts of the code
            })
            vim.cmd[[colorscheme NeoSolarized]]
        end,
    },
    -- FZF
    { "junegunn/fzf", build = "./install --bin" },
    "junegunn/fzf.vim",


    -- Git
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    {
        "shumphrey/fugitive-gitlab.vim",
        dependencies = {
            "tpope/vim-fugitive",
        },
    },

    -- GBrowse
    {
        "shumphrey/fugitive-gitlab.vim",
        dependencies = {
            "tpope/vim-fugitive",
        },
    },

    -- Surround replacement
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    -- Tabularize
    { "godlygeek/tabular" },


    -- Ruby & Rails
    "vim-ruby/vim-ruby",
    "tpope/vim-rails",

    -- Testing
    "vim-test/vim-test",

    -- Lint
    { "dense-analysis/ale" },

    -- Snippet engine and prebuilt snippets
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local ls = require("luasnip")

            ls.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
            })

            require("luasnip.loaders.from_vscode").lazy_load()

            -- Tab/Shift-Tab keybindings for snippets
            vim.keymap.set({ "i", "s" }, "<Tab>", function()
                return ls.expand_or_jumpable() and "<Plug>luasnip-expand-or-jump" or "<Tab>"
            end, { expr = true, silent = true })

            vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
                return ls.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<S-Tab>"
            end, { expr = true, silent = true })
        end,
    },
    -- Optional: Markdown
    "preservim/vim-markdown",
})

