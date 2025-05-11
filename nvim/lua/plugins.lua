require("lazy").setup({
  -- Git
  "tpope/vim-fugitive",

  -- Ruby & Rails
  "vim-ruby/vim-ruby",
  "tpope/vim-rails",

  -- Testing
  "vim-test/vim-test",

  -- FZF
  { "junegunn/fzf", build = "./install --bin" },
  "junegunn/fzf.vim",

  -- Optional: Markdown
  "preservim/vim-markdown",
})
