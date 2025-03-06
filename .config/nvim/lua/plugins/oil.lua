return {
  "stevearc/oil.nvim",

  config = function()
    local oil = require("oil")
    local fzf = require("fzf-lua")
    oil.setup({
      keymaps = {
        ["<C-v>"] = { "actions.preview", opts = { split = "botright" } },
        ["<C-g>"] = function()
          fzf.fzf_exec("fd --type d --hidden --follow --exclude .git", {
            prompt = "Find Directory: ",
            actions = {
              ["default"] = function(selected)
                oil.open(selected[1])
              end
            }
          })
        end,
        ["<C-p>"] = function()
          fzf.fzf_exec("fd --type f --hidden --follow --exclude .git", {
            prompt = "Find File: ",
            actions = {
              ["default"] = function(selected)
                oil.open(selected[1])
              end
            }
          })
        end,
        ["<leader>ff"] = function()
          fzf.files({ cwd = oil.get_current_dir() })
        end,
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          local m = name:match('^..$')
          return m ~= nil
        end
      },
      skip_confirm_for_simple_edits = true,
    })
    vim.keymap.set("n", "-", ":Oil<CR>", {})
    vim.cmd("Oil")
  end,
}
