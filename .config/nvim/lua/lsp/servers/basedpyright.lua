return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",         -- Turn off type checking to reduce noise
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly", -- Only check open files
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}
