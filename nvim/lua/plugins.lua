require("lazy").setup({
    -- Colorscheme
    {
        "ishan9299/nvim-solarized-lua",
        priority = 1000,
        config = function()
            vim.opt.termguicolors = true
            vim.opt.background = "dark"
            vim.cmd[[colorscheme solarized]]
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

    -- Snippets: UltiSnips instead of LuaSnip
    {
        "SirVer/ultisnips",
        event = "InsertEnter",
    },
    {
        "honza/vim-snippets",
        event = "InsertEnter",
    },

    -- Autocompletion with cmp and UltiSnips
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "quangnguyen30192/cmp-nvim-ultisnips",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            -- "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
        },
        config = function()
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
        end,
    },
})

