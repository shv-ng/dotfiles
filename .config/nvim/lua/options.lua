local set = vim.opt

set.nu = true             -- enable line numbers
set.relativenumber = true --relative line numbers
set.linebreak = true
set.colorcolumn = "80"
set.textwidth = 80
vim.cmd [[highlight ColorColumn ctermbg=darkgray guibg=#2e2e2e]]

-- Set indentation and tab behavior
set.expandtab = true -- Convert tabs to spaces
set.tabstop = 2      -- Tab width of 2 spaces
set.softtabstop = 2  -- Backspace/delete treats tab as 2 spaces
set.shiftwidth = 2   -- Indentation width of 2 spaces

-- Python-specific indentation (4 spaces for Python)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.textwidth = 88 -- Black's default
    vim.opt_local.colorcolumn = "88"
  end,
})

-- General settings
set.swapfile = false -- Disable swap files
set.scrolloff = 8    -- Keep 8 lines visible when scrolling
set.winborder = "rounded"

-- folding
set.foldmethod = "indent"
set.foldlevel = 10
set.foldclose = "all"


vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})


vim.lsp.handlers["textDocument/inlayHint"] = vim.lsp.handlers["textDocument/inlayHint"] or function(err, result, ctx)
  if not err then
    vim.lsp.util.on_inlay_hint(ctx.bufnr, result)
  end
end

if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end


-- local session_file = "Session.vim"
--
--
-- -- Load session if it exists
-- if vim.fn.filereadable(session_file) == 1 then
--   vim.cmd("source " .. session_file)
--   vim.defer_fn(function()
--     vim.cmd("doautocmd BufRead")
--   end, 50)
-- end
--
--
-- -- Auto-save session on exit
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   callback = function()
--     if vim.fn.filereadable(session_file) == 1 then
--       vim.cmd("mksession!")
--     end
--   end,
-- })

vim.diagnostic.config({
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
    source = "if_many",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
})
