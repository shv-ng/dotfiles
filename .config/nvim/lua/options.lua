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
if vim.fn.filereadable("./.nvimrc") == 1 then
  vim.cmd("source ./.nvimrc")
end
vim.lsp.handlers["textDocument/inlayHint"] = vim.lsp.handlers["textDocument/inlayHint"] or function(err, result, ctx)
  if not err then
    vim.lsp.util.on_inlay_hint(ctx.bufnr, result)
  end
end

if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end


-- load previous state
if vim.fn.filereadable("./Session.vim") == 1 then
  vim.cmd("source ./Session.vim")
end
