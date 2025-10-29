vim.o.number         = true
vim.o.relativenumber = true
vim.o.wrap           = false
vim.o.signcolumn     = "yes"
vim.o.colorcolumn    = "80"
vim.o.swapfile       = false
vim.o.termguicolors  = true
vim.o.winborder      = "rounded"
vim.o.cursorcolumn   = false
vim.o.ignorecase     = true
vim.o.smartindent    = true
vim.o.undofile       = true
vim.o.incsearch      = true
vim.o.scrolloff      = 10
vim.o.expandtab      = true
vim.o.tabstop        = 2
vim.o.softtabstop    = 2
vim.o.shiftwidth     = 2

vim.g.mapleader      = " "

local map            = vim.keymap.set

map("n", "<leader>o", ":update<CR>:source<CR>")
map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")

map({ "n", "v" }, "<leader>y", "\"+y")
map({ "n", "v" }, "<leader>Y", "\"+Y")
map({ "n", "v" }, "<leader>p", "\"+p")
map({ "n", "v" }, "<leader>P", "\"+P")

map({ "n", "v" }, "<leader>s", ":e #<CR>")
map({ "n", "v" }, "<leader>1", ":e #2<CR>")
map({ "n", "v" }, "<leader>2", ":e #3<CR>")
map({ "n", "v" }, "<leader>3", ":e #4<CR>")
map("n", "<leader>n", ":noh<CR>")

map("n", "<C-h>", ":wincmd h<CR>")
map("n", "<C-j>", ":wincmd j<CR>")
map("n", "<C-k>", ":wincmd k<CR>")
map("n", "<C-l>", ":wincmd l<CR>")

map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "J", ":m '>+1<CR>gv=gv")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("n", "<M-j>", ":cnext<CR>")
map("n", "<M-k>", ":cprev<CR>")

map("n", "<leader>x", function() vim.cmd("!chmod +x " .. vim.fn.expand("%")) end)
map("n", "<leader>ge", function()
  vim.api.nvim_put({ "if err != nil {", "    return err", "}" }, "l", true, true)
end)

vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
})

require "oil".setup({
  skip_confirm_for_simple_edits = true,
})
require "fzf-lua".setup()
require "nvim-treesitter.configs".setup({
  ensure_installed = { "lua", "go" },
  sync_install = true,
  ignore_install = {},
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  modules = {}
})
require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono'
  },
  sources = {
    default = { 'lsp', 'path', 'buffer' },
  },
  fuzzy = {
    use_fzf = true,
    use_proximity = true,
  },
  windows = {
    show_documentation = true
  }
})
require("typst-preview").setup()

map("n", "<leader>e", ":FzfLua files<CR>")
map("n", "<leader>fb", ":FzfLua buffers<CR>")
map("n", "<leader>fl", ":FzfLua live_grep<CR>")
map("n", "<leader>fz", ":FzfLua<CR>")
map({ "n", "i" }, "<F1>", ":FzfLua helptags<CR>")

map("n", "-", ":Oil<CR>")

map("n", "<leader>lf", vim.lsp.buf.format)
map("n", "gd", vim.lsp.buf.definition)
map("i", "<C-k>", vim.lsp.buf.signature_help)

vim.lsp.enable({ "lua_ls", "gopls", "tinymist", "ruff" })

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      }
    }
  }
})
vim.lsp.config("tinymist", {
  settings = {
    formatterMode = "typstyle",
    exportPdf = "onType",
    semanticTokens = "disable"
  }
})


vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = true })
    -- only for go
    if vim.bo.filetype == "go" then
      vim.lsp.buf.code_action {
        context = {
          diagnostics = {},
          only = { "source.organizeImports" },
        },
        apply = true,
      }
    end
  end,
})

vim.lsp.handlers["textDocument/inlayHint"] = vim.lsp.handlers["textDocument/inlayHint"] or function(err, result, ctx)
  if not err then
    vim.lsp.util.on_inlay_hint(ctx.bufnr, result)
  end
end

if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end

vim.cmd("colorscheme tokyonight")

vim.cmd [[
    highlight Normal      ctermbg=NONE     guibg=NONE
    highlight NonText     ctermbg=NONE     guibg=NONE
    highlight SignColumn  ctermbg=NONE     guibg=NONE
    highlight EndOfBuffer ctermbg=NONE     guibg=NONE
    highlight statusline  ctermbg=NONE     guibg=NONE
    highlight ColorColumn ctermbg=darkgray guibg=#2e2e2e
]]
