local fzf = require('fzf-lua')

local function pick_worktree()
  local handle = io.popen('git worktree list')
  local output = handle:read("*a")
  handle:close()

  local worktrees = {}
  for line in output:gmatch("[^\r\n]+") do
    local path = line:match("^(%S+)")
    if path and not path:match("%(bare%)") then
      table.insert(worktrees, path)
    end
  end

  fzf.fzf_exec(worktrees, {
    prompt = 'Worktrees> ',
    actions = {
      ['default'] = function(selected)
        -- Save current buffers
        local buffers = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            if name ~= "" then
              table.insert(buffers, name)
            end
          end
        end

        -- Change directory
        vim.api.nvim_set_current_dir(selected[1])

        -- Restore buffers
        for _, buf_name in ipairs(buffers) do
          vim.cmd("badd " .. vim.fn.fnameescape(buf_name))
        end

        vim.cmd("Oil" .. selected[1])
      end
    }
  })
end
-- Optionally create a keybinding
vim.keymap.set('n', '<C-g>', pick_worktree, { desc = 'Pick Git Worktree' })

-- Return the function for direct use
return pick_worktree
