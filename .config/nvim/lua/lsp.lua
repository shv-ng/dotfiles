vim.lsp.enable({
  "lua_ls", "gopls", "tinymist", "ruff", "yamlls", "ts_ls",
  "svelte-language-server", "clangd", "ty"
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      }
    }
  }
})

vim.lsp.config("tinymist", {
  settings = {
    formatterMode = "typstyle",
    exportPdf = "onType",
    semanticTokens = "disable"
  }
})

vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_dir = vim.fs.root(0, { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' }),
  settings = {
    ty = {
    }
  }
})


MAP("n", "<leader>lf", vim.lsp.buf.format)
MAP("n", "gd", vim.lsp.buf.definition)
MAP("i", "<C-k>", vim.lsp.buf.signature_help)
