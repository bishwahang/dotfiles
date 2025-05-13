require("lazy").setup({
    -- Colorscheme
    {
        "ishan9299/nvim-solarized-lua",
        priority = 1000,
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
    },

    -- Tabularize
    { "godlygeek/tabular" },

    -- Ruby and Rails
    {
        "vim-ruby/vim-ruby",
        lazy = false,
    },

    {
        "tpope/vim-projectionist",
        lazy = false,  -- Remove the event-based loading
    },

    {
        "tpope/vim-rails",
        dependencies = {"tpope/vim-projectionist"},  -- Explicitly define the dependency
        lazy = false,
    },

    {
        "tpope/vim-projectionist",
        lazy = false,
        event = "BufReadPre",
    },

    -- Asynchronous build & test dispatcher
    { "tpope/vim-dispatch" },
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
    },

    {
        'https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim.git',
        -- Activate when a file is created/opened
        event = { 'BufReadPre', 'BufNewFile' },
        -- Activate when a supported filetype is open
        ft = { 'go', 'javascript', 'python', 'ruby' },
        cond = function()
            -- Only activate if token is present in environment variable.
            -- Remove this line to use the interactive workflow.
            return vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= ''
        end,
    }
})
