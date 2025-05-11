vim.api.nvim_create_augroup("RestoreCursorGroup", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = "RestoreCursorGroup",
  pattern = "*",
  callback = function()
    local line = vim.fn.line([['"]])
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})

