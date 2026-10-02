return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        codebook = {
          filetypes = {
            "c",
            "cpp",
            "css",
            "dart",
            "gitcommit",
            "go",
            "haskell",
            "html",
            "java",
            "javascript",
            "javascriptreact",
            "lua",
            "markdown",
            "php",
            "python",
            "ruby",
            "rust",
            "sh",
            "swift",
            "toml",
            "text",
            "typescript",
            "typescriptreact",
            "vue",
            "yaml",
            "zig",
          },
          init_options = {
            checkWhileTyping = true,
            globalConfigPath = vim.fn.expand("~/.config/codebook/codebook.toml"),
          },
          setup = function()
            vim.lsp.enable("codebook")
          end,
        },
      },
    },
  },
}
