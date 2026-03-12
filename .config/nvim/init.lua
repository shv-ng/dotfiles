vim.o.number         = true
vim.o.relativenumber = true
vim.o.wrap           = false
vim.o.signcolumn     = "yes"
vim.o.colorcolumn    = "100"
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
vim.o.exrc           = true
vim.o.fillchars      = "fold: "
vim.o.foldmethod     = "manual"
vim.o.foldtext       = "v:lua.CustomFoldText()"
vim.o.foldcolumn     = '1'
vim.g.mapleader      = " "


local map = vim.keymap.set
map("n", "<leader>o", ":update<CR>:source<CR>")
map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")

map({ "n", "v" }, "<leader>y", "\"+y")
map({ "n", "v" }, "<leader>Y", "\"+Y")
map({ "n", "v" }, "<leader>p", "\"+p")
map({ "n", "v" }, "<leader>P", "\"+P")

map({ "n", "v" }, "<leader>s", ":e #<CR>")
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

map("n", "<Tab>", "za")
map("n", "zp", "$zf%")
map("v", "f", "zf")

map("n", "<leader>x", function() vim.cmd("!chmod +x " .. vim.fn.expand("%")) end)
map("n", "<leader>ge", function()
  vim.api.nvim_put({ "if err != nil {", "    return err", "}" }, "l", true, true)
end)
map("n", "<leader>gs", function()
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

vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  --  { src = "https://github.com/monkoose/neocodeium" },
})


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
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
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

require "fzf-lua".setup()
require "fzf-lua".register_ui_select()

map("n", "<leader>e", ":FzfLua files<CR>")
map("n", "<leader>fb", ":FzfLua buffers<CR>")
map("n", "<leader>fl", ":FzfLua live_grep<CR>")
map("n", "<leader>fz", ":FzfLua<CR>")
map({ "n", "i" }, "<F1>", ":FzfLua helptags<CR>")

map("n", "<leader>lf", vim.lsp.buf.format)
map("n", "gd", vim.lsp.buf.definition)
map("i", "<C-k>", vim.lsp.buf.signature_help)

require "oil".setup({ skip_confirm_for_simple_edits = true })
map("n", "-", ":Oil<CR>")

-- require("neocodeium").setup({ enabled = false })
-- local neocodeium = require("neocodeium")
-- map("i", "<A-f>", neocodeium.accept)
-- map("n", "<leader>c", ":NeoCodeium toggle<cr>")

vim.lsp.enable({
  "lua_ls", "gopls", "tinymist", "ruff", "yamlls", "basedpyright", "ts_ls",
  "svelte-language-server", "clangd"
})


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

vim.lsp.config("basedpyright", {
  analysis = {
    diagnosticMode = "openFilesOnly",
    inlayHints = {
      callArgumentNames = false
    }
  }
})


vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "python" then
      return
    end
    vim.lsp.buf.format({ async = false })
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

vim.lsp.handlers["textDocument/inlayHint"] = vim.lsp.handlers["textDocument/inlayHint"]
    or function(err, result, ctx)
      if not err then
        vim.lsp.util.on_inlay_hint(ctx.bufnr, result)
      end
    end

if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true, { 0 })
end

vim.cmd("colorscheme tokyonight")

vim.cmd [[
    highlight Normal       ctermbg=NONE     guibg=NONE
    highlight NonText      ctermbg=NONE     guibg=NONE
    highlight SignColumn   ctermbg=NONE     guibg=NONE
    highlight EndOfBuffer  ctermbg=NONE     guibg=NONE
    highlight statusline   ctermbg=NONE     guibg=NONE
    highlight ColorColumn  ctermbg=darkgray guibg=#2e2e2e
    highlight NormalNC     ctermbg=NONE     guibg=NONE
    highlight SignColumnNC ctermbg=NONE     guibg=NONE
]]

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
