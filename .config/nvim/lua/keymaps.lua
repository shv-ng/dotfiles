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

-- toggle inlay hint
vim.keymap.set("n", "<leader>ih", function()
  local buf = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
end, { desc = "Toggle Inlay Hints" })

-- Quick fix
vim.keymap.set("n", "<M-j>", ":cnext<CR>")
vim.keymap.set("n", "<M-k>", ":cprev<CR>")


-- lsp keymaps

-- Golang error check helper GE: goo error
vim.keymap.set("n", "<leader>ge", function()
  vim.api.nvim_put({ "if err != nil {", "    return err", "}" }, "l", true, true)
end, { desc = "Insert Go error check" })


local smart_format = require("lsp.format").smart_format
local opts = { silent = true }

vim.keymap.set("n", "gd", ":FzfLua lsp_definitions<CR>", opts)
vim.keymap.set("n", "gD", ":FzfLua lsp_declarations<CR>", opts)
vim.keymap.set("n", "gi", ":FzfLua lsp_implementations<CR>", opts)
vim.keymap.set("n", "gr", ":FzfLua lsp_references<CR>", opts)

vim.keymap.set('n', 'K', ':lua vim.lsp.buf.hover()<cr>', opts)
vim.keymap.set('n', '<C-k>', ':lua vim.lsp.buf.signature_help()<cr>', opts)
vim.keymap.set('n', '<F2>', ':lua vim.lsp.buf.rename()<cr>', opts)
vim.keymap.set('n', '<F4>', ":FzfLua lsp_code_actions<CR>", opts)
vim.keymap.set('n', '<F3>', smart_format, opts)

vim.keymap.set("n", "<leader>gl", ":FzfLua diagnostics_documentCR>", opts)

-- FzfLua shortcuts
vim.keymap.set("n", "<C-p>", ":FzfLua files<CR>", opts)
vim.keymap.set("n", "<leader>fl", ":FzfLua live_grep<CR>", opts)
vim.keymap.set("n", "<leader>fz", ":FzfLua<CR>", opts)
vim.keymap.set("n", "<F11>", ":FzfLua buffers<CR>", opts)
vim.keymap.set({ "n", "i" }, "<F1>", ":FzfLua helptags<CR>", opts)


-- open tmux sessionizer
vim.keymap.set("n", "<C-f>", ":!tmux new-window tmux-sessionizer<CR>")
