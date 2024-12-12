return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})

      vim.keymap.set("n", "<leader>ca", function()
        require("telescope.builtin").lsp_code_actions()
      end, { noremap = true, silent = true })
      require("telescope").load_extension("ui-select")
    end,
  },
}
