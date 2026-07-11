vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
  pattern = "*",
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })

    local has_formatter = false
    for _, client in ipairs(clients) do
      if client:supports_method("textDocument/formatting", args.buf) then
        has_formatter = true
        break
      end
    end

    if has_formatter then
      vim.lsp.buf.format({ bufnr = args.buf, async = false })
    end

    if vim.bo.filetype == "go" then
      vim.lsp.buf.code_action({
        context = {
          diagnostics = {},
          only = { "source.organizeImports" },
        },
        apply = true,
      })
    end
  end,
})
