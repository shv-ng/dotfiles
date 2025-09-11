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
        enable = false, -- We use null-ls for formatting
      },
    },
  },
  on_attach = function(client, _)
    -- Disable hover and formatting in favor of basedpyright and null-ls
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
