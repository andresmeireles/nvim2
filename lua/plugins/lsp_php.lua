return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpantom_lsp = {
          cmd = { "phpantom_lsp" },
          filetypes = { "php", "blade" },
          root_markers = { ".phpantom.toml", "composer.json", ".git" },
        },
      },
    },
  },
}
