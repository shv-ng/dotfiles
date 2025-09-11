local M = {}
function M.smart_format()
  local ft = vim.bo.filetype
  local fname = vim.api.nvim_buf_get_name(0)

  if ft == "htmldjango" or fname:match("%.html$") then
    vim.cmd("!djlint % --reformat --indent=2 --max-line-length=80")
  elseif ft == "sh" then
    vim.cmd("!beautysh %")
  elseif ft == "python" then
  else
    vim.lsp.buf.format({ async = true })
  end
end

return M
