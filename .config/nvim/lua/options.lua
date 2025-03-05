vim.opt.nu = true             -- enable line numbers
vim.opt.relativenumber = true --relative line numbers

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
  pattern = "*",
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.cmd([[
    command! FormatAll lua vim.lsp.buf.format({async = true})
]])

vim.lsp.handlers["textDocument/inlayHint"] = vim.lsp.handlers["textDocument/inlayHint"] or function(err, result, ctx)
  if not err then
    vim.lsp.util.on_inlay_hint(ctx.bufnr, result)
  end
end

if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end


local session_file = "Session.vim"

-- Load session if it exists
if vim.fn.filereadable(session_file) == 1 then
  vim.cmd("source " .. session_file)
  vim.defer_fn(function()
    vim.cmd("doautocmd BufRead")
  end, 50)
end


-- Auto-save session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if vim.fn.filereadable(session_file) == 1 then
      vim.cmd("mksession!")
    end
  end,
})
