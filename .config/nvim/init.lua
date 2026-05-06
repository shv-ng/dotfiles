---@diagnostic disable-next-line: duplicate-set-field
package.preload["cmp"] = function()
  return {
    register_source = function() end,
  }
end

require "options"
require "autocmd"
require "fold"
require "keymaps"
require "lsp"
require "plugins"
require "ui"

require "plugin.fzf_lua"
require "plugin.supermaven"
require "plugin.blink"
require "plugin.oil"
require "plugin.treesitter"
require "plugin.typst_preview"
