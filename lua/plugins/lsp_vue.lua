return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
      local vue_language_server_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"

      opts.servers = opts.servers or {}

      opts.servers.vtsls = {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                },
              },
            },
          },
        },
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
      }

      opts.servers.vue_ls = {
        filetypes = { "vue" },
      }
    end,
  },
}
