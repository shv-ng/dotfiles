return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    enabled = true,
    config = function()
      local neocodeium = require("neocodeium")
      neocodeium.setup()
      vim.keymap.set("i", "<A-f>", neocodeium.accept)
      vim.keymap.set("n", "<leader>nt", ":NeoCodeium toggle<CR>")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets',
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        config = function()
          require('luasnip.loaders.from_lua').load({ paths = { '~/.config/nvim/snippets/' } })
        end
      },
    },

    version = '*',

    opts = {
      keymap = {
        preset = 'default',
        ['<C-y>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-space>'] = { 'select_and_accept' },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      snippets = { preset = 'luasnip' },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', "lazydev", },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
        per_filetype = {
          lua = { "lsp", "path", "snippets", "buffer", "lazydev" },
          go  = { "lsp", "path", "snippets", "buffer" }, -- no lazydev here
        },
      },
    },
    opts_extend = { "sources.default" }
  },
}
