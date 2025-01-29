return { {
  "hrsh7th/cmp-nvim-lsp"
},
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" }
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),

        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
      })
      local ls = require("luasnip")

      -- Load HTML snippets
      ls.add_snippets("html", require("snippets.html"))
    end,
  },
}
