local M = {}

local function get_worktrees()
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
  return worktrees
end

function M.wt_picker()
  local fzf = require('fzf-lua')
  local worktrees = get_worktrees()

  -- If only one worktree, don't do anything
  if #worktrees <= 1 then
    print("Only one worktree found, nothing to switch")
    return
  end

  fzf.fzf_exec(worktrees, {
    prompt = 'Worktrees> ',
    actions = {
      ['default'] = function(selected)
        vim.api.nvim_set_current_dir(selected[1])
        vim.cmd("Oil" .. selected[1])
      end
    }
  })
end

function M.wt_cd()
  local buf_path = vim.api.nvim_buf_get_name(0)
  if buf_path == "" then
    print("No file in current buffer")
    return
  end

  local worktrees = get_worktrees()

  -- Sort worktrees by length (longest first) to match most specific path
  table.sort(worktrees, function(a, b) return #a > #b end)

  -- Find which worktree this buffer belongs to
  for _, wt_path in ipairs(worktrees) do
    if buf_path:find(wt_path, 1, true) == 1 then
      vim.api.nvim_set_current_dir(wt_path)
      print("Changed directory to: " .. wt_path)
      return
    end
  end

  print("Buffer is not in any worktree")
end

return M
