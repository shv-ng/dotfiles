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

-- Plugin
vim.keymap.set({ "n", "v" }, "<leader>/", ":CommentToggle<CR>")
