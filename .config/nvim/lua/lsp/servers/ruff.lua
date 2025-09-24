return {
  init_options = {
    settings = {
      -- Configure ruff with all settings inline
      lint = {
        enable = true,
        select = {
          "E",   -- pycodestyle errors
          "W",   -- pycodestyle warnings
          "F",   -- pyflakes
          "I",   -- isort
          "B",   -- flake8-bugbear
          "C4",  -- flake8-comprehensions
          "UP",  -- pyupgrade
          "N",   -- pep8-naming
          "YTT", -- flake8-2020
          "S",   -- bandit
        },
        ignore = {
          "E501", -- line too long (handled by black)
          "S101", -- use of assert
          "S603", -- subprocess without shell=True
        },
      },
      format = {
        enable = true, -- We use null-ls for formatting
      },
    },
  },
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = true
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
  end,
}
