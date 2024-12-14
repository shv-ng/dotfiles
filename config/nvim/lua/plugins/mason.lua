return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {},
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pylsp",    -- Python LSP
          "lua_ls",   -- Lua LSP
          "rust_analyzer", -- Rust LSP
        },
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim" },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "black",  -- Python formatter
          "flake8", -- Python linter
          "mypy",   -- Python type checker
          "prettier", -- JS/TS/CSS/HTML formatter
          "stylua", -- Lua formatter
          "shellharden", -- Shell script formatter
          "shellcheck", -- Shell script linter
        },
        automatic_setup = true,
      })
      require("null-ls").setup()
    end,
  },
}
