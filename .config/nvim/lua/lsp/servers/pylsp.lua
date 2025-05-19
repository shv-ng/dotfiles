return {
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
}
