return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ mode = "n", global = false })
      end,
      desc = "Show Buffer-local Keymaps",
    },
  },
}
