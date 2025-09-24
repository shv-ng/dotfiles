return {
  "ibhagwan/fzf-lua",
  config = function()
    require('fzf-lua').setup({
      files = {
        formatter = "path.filename_first",
      },
      winopts = {
        fullscreen = true,
        border = "none",   -- Remove window border
        preview = {
          border = "none", -- Remove preview border
          default = "bat"
        }
      },
      fzf_opts = {
        ['--no-border'] = '',    -- Remove fzf's internal border
        ['--no-separator'] = '', -- Remove separator line
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --regexp"
      },
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept"
        }
      },
    })
    -- Register UI select to fix warning
    require('fzf-lua').register_ui_select()
  end
}
