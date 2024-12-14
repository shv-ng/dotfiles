return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- Formatters
        null_ls.builtins.formatting.stylua,  -- Lua formatter
        null_ls.builtins.formatting.prettier, -- JS/TS/CSS/HTML formatter
        null_ls.builtins.formatting.shellharden, -- Shell script formatter
        null_ls.builtins.formatting.black,   -- Python formatter (PEP 8)

        -- Diagnostics (Linters)
        null_ls.builtins.diagnostics.mypy,   -- Python type checking
        null_ls.builtins.diagnostics.flake8, -- Python linter (PEP 8 compliance)
        null_ls.builtins.diagnostics.shellcheck, -- Shell script linter

        -- Custom tools
        null_ls.builtins.code_actions.refactoring, -- Refactoring suggestions
      },
    })

    -- Keybinding for formatting
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
