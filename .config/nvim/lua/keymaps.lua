MAP = vim.keymap.set

MAP("n", "<leader>o", ":update<CR>:source<CR>")
MAP("n", "<leader>w", ":write<CR>")
MAP("n", "<leader>q", ":quit<CR>")

MAP({ "n", "v" }, "<leader>y", "\"+y")
MAP({ "n", "v" }, "<leader>Y", "\"+Y")
MAP({ "n", "v" }, "<leader>p", "\"+p")
MAP({ "n", "v" }, "<leader>P", "\"+P")

MAP({ "n", "v" }, "<leader>s", ":e #<CR>")
MAP("n", "<leader>n", ":noh<CR>")

MAP("n", "<C-h>", ":wincmd h<CR>")
MAP("n", "<C-j>", ":wincmd j<CR>")
MAP("n", "<C-k>", ":wincmd k<CR>")
MAP("n", "<C-l>", ":wincmd l<CR>")

MAP("v", "K", ":m '<-2<CR>gv=gv")
MAP("v", "J", ":m '>+1<CR>gv=gv")

MAP("n", "<C-d>", "<C-d>zz")
MAP("n", "<C-u>", "<C-u>zz")

MAP("n", "n", "nzzzv")
MAP("n", "N", "Nzzzv")

MAP("n", "<M-j>", ":cnext<CR>")
MAP("n", "<M-k>", ":cprev<CR>")

MAP("n", "<Tab>", "za")
MAP("n", "zp", "$zf%")
MAP("v", "f", "zf")

MAP("n", "<leader>ge", function()
  vim.api.nvim_put({ "if err != nil {", "    return fmt.Errorf(\": %w\",err)", "}" }, "l", true, true)
end)

MAP("n", "<leader>gs", function()
  local old_name = vim.fn.expand("<cword>")
  local first_char = old_name:sub(1, 1)
  local new_name

  if first_char:find("%l") then
    new_name = first_char:upper() .. old_name:sub(2)
  else
    new_name = first_char:lower() .. old_name:sub(2)
  end
  vim.lsp.buf.rename(new_name)
end)
