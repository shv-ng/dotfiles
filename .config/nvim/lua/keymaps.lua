-- space bar leader key
vim.g.mapleader = " "

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")


vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Copy/paste to/from clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])

-- Movement in wrapped line
vim.keymap.set({ "n", "v" }, "j", "gj", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "k", "gk", { noremap = true, silent = true })

-- Change buffer
vim.keymap.set("n", "<leader>[", ":bprevious<CR>", { noremap = true, silent = true }) -- Go to previous buffer
vim.keymap.set("n", "<leader>]", ":bnext<CR>", { noremap = true, silent = true })     -- Go to next buffer

-- Tab
vim.keymap.set("n", "<leader>tc", ":tabnew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tp", ":tabprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { noremap = true, silent = true })




-- Fzf Lua
vim.keymap.set("n", "<C-p>", ":FzfLua files<CR>", { silent = true })
vim.keymap.set("n", "<leader><leader>", ":FzfLua live_grep<CR>", { silent = true })
vim.keymap.set("n", "<leader>fg", ":FzfLua buffers<CR>", { silent = true })
vim.keymap.set("n", "<leader>fl", ":FzfLua<CR>", { silent = true })

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>x", function()
  vim.cmd("!chmod +x " .. vim.fn.expand("%"))
end)

vim.keymap.set("x", "j", "jzz")
vim.keymap.set("x", "k", "kzz")
