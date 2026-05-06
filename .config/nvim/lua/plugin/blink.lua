require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono'
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
  },
  sources = {
    default = { 'lsp', 'path', 'buffer' },
    providers = {
      lsp = {
        min_keyword_length = 1,
        score_offset = 101,
      },
    }
  },
  fuzzy = {
    use_proximity = true,
  },
})
