return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()

      -- Auto-install formatters and tools
      local registry = require("mason-registry")
      local packages = {
        "black",
        "isort",
        "ruff",
        "shellcheck",

        "basedpyright",
        "bash-language-server",
        "emmet-language-server",
        "gopls",
        "lua-language-server",
      }

      for _, package in ipairs(packages) do
        local p = registry.get_package(package)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
}
