vim.g.mapleader = " " -- Set space as the leader key

-- Window navigation shortcuts
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

-- Copy/paste using system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")
vim.keymap.set({ "n", "v" }, "<leader>Y", "\"+Y")
vim.keymap.set({ "n", "v" }, "<leader>p", "\"+p")
vim.keymap.set({ "n", "v" }, "<leader>P", "\"+P")

-- Smooth movement in wrapped lines
vim.keymap.set({ "n", "v" }, "j", "gj", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "k", "gk", { noremap = true, silent = true })

-- Buffer navigation
vim.keymap.set("n", "<leader>[", ":bprevious<CR>", { silent = true }) -- Previous buffer
vim.keymap.set("n", "<leader>]", ":bnext<CR>", { silent = true })     -- Next buffer

-- Tab management
vim.keymap.set("n", "<leader>tc", ":tabnew<CR>", { silent = true })      -- New tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { silent = true })    -- Close tab
vim.keymap.set("n", "<leader>tp", ":tabprevious<CR>", { silent = true }) -- Prev tab
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { silent = true })     -- Next tab

-- FzfLua shortcuts
vim.keymap.set("n", "<C-p>", ":FzfLua files<CR>", { silent = true })                -- Search files
vim.keymap.set("n", "<leader><leader>", ":FzfLua live_grep<CR>", { silent = true }) -- Live grep
vim.keymap.set("n", "<leader>fg", ":FzfLua buffers<CR>", { silent = true })         -- Search buffers
vim.keymap.set("n", "<leader>fl", ":FzfLua<CR>", { silent = true })                 -- Open FzfLua
vim.keymap.set("n", "<leader>ff", ":FzfLua files cwd=%:p:h<CR>")


-- Move selected lines up/down in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Keep cursor centered when scrolling/searching
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Make current file executable
vim.keymap.set("n", "<leader>x", function()
  vim.cmd("!chmod +x " .. vim.fn.expand("%"))
end)

-- change filetype to htmldjango
vim.keymap.set("n", "<leader>dj", ":set filetype=htmldjango<CR>")
