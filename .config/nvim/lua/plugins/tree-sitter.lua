return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdateSync",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup {
        auto_install = true, highlight = { enable = true },
        indent = { enable = true },
      }
    end
  },
}
