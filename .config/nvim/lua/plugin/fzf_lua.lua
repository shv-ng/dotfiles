local fzf_lua = require("fzf-lua")

fzf_lua.setup()
fzf_lua.register_ui_select()



local function files_with_frec()
  local ns = vim.fn.getcwd()
  ns = ns:gsub("/", "_")

  fzf_lua.fzf_exec(function(fzf_cb)
    vim.fn.system("fd --type f --hidden --exclude .git | frec sync " .. ns)

    local ordered = vim.fn.systemlist("frec list " .. ns .. " | awk -F'  ' '{print $1}'")
    for _, entry in ipairs(ordered) do
      fzf_cb(entry)
    end
    fzf_cb()
  end, {
    prompt  = "Files ❯ ",
    cwd     = cwd,
    actions = {
      ["default"] = function(selected)
        vim.fn.system("frec add " .. ns .. " " .. vim.fn.shellescape(selected[1]))
        fzf_lua.actions.file_edit(selected, { cwd = cwd })
      end,
      ["ctrl-s"] = fzf_lua.actions.file_split,
      ["ctrl-v"] = fzf_lua.actions.file_vsplit,
      ["ctrl-t"] = fzf_lua.actions.file_tabedit,
    },
  })
end

MAP("n", "<leader>e", files_with_frec)
MAP("n", "<leader>fb", ":FzfLua buffers<CR>")
MAP("n", "<leader>fl", ":FzfLua live_grep<CR>")
MAP("n", "<leader>fz", ":FzfLua<CR>")
MAP({ "n", "i" }, "<F1>", ":FzfLua helptags<CR>")
