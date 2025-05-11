local function smart_format()
  local ft = vim.bo.filetype
  local fname = vim.api.nvim_buf_get_name(0)

  if ft == "htmldjango" or fname:match("%.html$") then
    vim.cmd("!djlint % --reformat --indent=2 --max-line-length=80")
  elseif ft == "sh" then
    vim.cmd("!beautysh %")
  else
    vim.lsp.buf.format({ async = true })
  end
end

return {


  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "blink.cmp" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },


  },
  init = function()
    vim.opt.signcolumn = "yes"
  end,
  config = function()
    local lsp_defaults = require("lspconfig").util.default_config

    lsp_defaults.capabilities =
        vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("blink.cmp").get_lsp_capabilities())

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', smart_format, opts)
        vim.keymap.set('n', '<F4>', "<cmd>FzfLua lsp_code_actions<CR>", opts)
      end,
    })

    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "basedpyright", "pylsp", "ruff", "emmet_language_server", "gopls" },
      automatic_installation = true,
      handlers = {

        pyright = function()
          require("lspconfig").basedpyright.setup({
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "off",
                  autoImportCompletions = true,
                  diagnosticMode = "workspace",
                },
              },
            },
          })
        end,

        pylsp = function()
          require("lspconfig").pylsp.setup({
            settings = {
              pylsp = {
                -- Only use pylsp for completions (jedi under the hood)
                plugins = {
                  pyflakes = { enabled = false },
                  mccabe = { enabled = false },
                  pycodestyle = { enabled = false },
                  pydocstyle = { enabled = false },
                  autopep8 = { enabled = false },
                },
              },
            },
          })
        end,

        html = function()
          require("lspconfig").html.setup({
            filetypes = { 'html', 'htmldjango' }
          })
        end,
        -- this first function is the "default handler"
        -- it applies to every language server without a "custom handler"
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
      },
    })
  end,

}
