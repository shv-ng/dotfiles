return {
  "MysticalDevil/inlay-hints.nvim",
  event = "LspAttach",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("inlay-hints").setup()
    require("lspconfig").pylyzer.setup({
      settings = {
        python = {
          inlayHints = true,
        },
      },
    })
  end,
}
