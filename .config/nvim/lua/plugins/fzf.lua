return {
  "ibhagwan/fzf-lua",
  config = function()
    require('fzf-lua').setup({
      winopts = {
        fullscreen = true,
        preview = {
          default = "bat"
        }
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
    require('plugins.fzf.custom')
  end
}
