return {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
  init = function()
    -- Reserve a space in the gutter
    -- This will avoid an annoying layout shift in the screen
    vim.opt.signcolumn = "yes"
  end,
  config = function()
    local lsp_defaults = require("lspconfig").util.default_config

    -- Add cmp_nvim_lsp capabilities settings to lspconfig
    -- This should be executed before you configure any language server
    lsp_defaults.capabilities =
        vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- LspAttach is where you enable features that only work
    -- if there is a language server active in the file
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
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      end,
    })

    require("mason-lspconfig").setup({
      ensure_installed = {},
      handlers = {

        pyright = function()
          require("lspconfig").basedpyright.setup({
            -- Waiting for a pylsp PR that improves its hover docs
            -- on_attach = function(client)
            -- 	client.server_capabilities.hoverProvider = false
            -- end,
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
        lua_ls = function()
          require("lspconfig").lua_ls.setup({
            settings = {
              diagnostics = {
                globals = {
                  "vim",
                },
              },
            },
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
