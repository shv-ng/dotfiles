vim.api.nvim_set_hl(0, "Folded", { fg = "#7f849c", bg = "NONE", italic = true })

vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#45475a", bg = "NONE" })

function CustomFoldText()
  local start_line = vim.fn.getline(vim.v.foldstart):gsub("^%s*", "")
  local line_count = vim.v.foldend - vim.v.foldstart + 1

  local win_width = vim.api.nvim_win_get_width(0)
  local gutter_width = vim.o.numberwidth + tonumber(vim.o.foldcolumn) + 2
  local target_width = win_width - gutter_width

  local fold_info = "    " .. start_line
  local stats = " " .. line_count .. " lines 󰁂 "

  local available_space = target_width - vim.fn.strdisplaywidth(fold_info) - vim.fn.strdisplaywidth(stats)

  if available_space < 0 then available_space = 1 end

  local spacing = string.rep(" ", available_space)

  return fold_info .. spacing .. stats
end
