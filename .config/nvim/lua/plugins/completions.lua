-- return { {
--   "hrsh7th/cmp-nvim-lsp"
-- },
--   {
--     "L3MON4D3/LuaSnip",
--     dependencies = {
--       "saadparwaiz1/cmp_luasnip",
--       "rafamadriz/friendly-snippets",
--     },
--   },
--   {
--     "hrsh7th/nvim-cmp",
--     event = "InsertEnter",
--     config = function()
--       local cmp = require("cmp")
--       require("luasnip.loaders.from_vscode").lazy_load()
--       local ELLIPSIS_CHAR = '…'
--       local MAX_LABEL_WIDTH = 20
--       local MIN_LABEL_WIDTH = 20
--       cmp.setup({
--         sources = {
--           { name = "nvim_lsp" },
--           { name = "luasnip" }
--         },
--         mapping = cmp.mapping.preset.insert({
--           ["<C-Space>"] = cmp.mapping.complete(),
--           ["<C-u>"] = cmp.mapping.scroll_docs(-4),
--           ["<C-d>"] = cmp.mapping.scroll_docs(4),
--           ['<CR>'] = cmp.mapping.confirm({ select = true }),
--
--         }),
--         snippet = {
--           expand = function(args)
--             vim.snippet.expand(args.body)
--           end,
--         },
--         window = {
--           completion = cmp.config.window.bordered(),
--           documentation = cmp.config.window.bordered(),
--         },
--         formatting = {
--           format = function(entry, vim_item)
--             local label = vim_item.abbr
--             local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
--             if truncated_label ~= label then
--               vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
--             elseif string.len(label) < MIN_LABEL_WIDTH then
--               local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
--               vim_item.abbr = label .. padding
--             end
--             return vim_item
--           end,
--         },
--       })
--       local ls = require("luasnip")
--
--       -- Load HTML snippets
--       ls.add_snippets("html", require("snippets.html"))
--     end,
--   },
-- }
return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',

  version = '*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'enter' },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = {
      menu = { auto_show = function(ctx) return ctx.mode ~= 'cmdline' end }
    }
  },
  opts_extend = { "sources.default" }
}
