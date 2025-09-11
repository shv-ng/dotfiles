return {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "blink.cmp" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
  init = function()
    vim.opt.signcolumn = "yes"
  end,
  config = function()
    local lspconfig = require("lspconfig")

    local lsp_defaults = lspconfig.util.default_config
    lsp_defaults.capabilities =
        vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("blink.cmp").get_lsp_capabilities())


    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls", 
        "basedpyright",  -- Main Python LSP
        "ruff",          -- Fast linting
        "emmet_language_server",
        "gopls", 
        "bashls"
      },
      automatic_installation = true,
      handlers = {
        function(server_name)
          local ok, opts = pcall(require, "lsp.servers." .. server_name)
          if ok then
            require("lspconfig")[server_name].setup(opts)
          end
          if not ok then
            require("lspconfig")[server_name].setup({})
          end
        end
      },
    })
  end,
}
