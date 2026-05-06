require "nvim-treesitter.configs".setup({
  ensure_installed = { "lua", "go" },
  sync_install = true,
  ignore_install = {},
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  modules = {}
})
