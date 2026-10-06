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

      opts.servers.tailwindcss = {
        filetypes = {
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              vue = "html",
            },
            classAttributes = {
              "class",
              "className",
              ":class",
              "v-bind:class",
              "class:list",
              "classList",
              "ngClass",
            },
            experimental = {
              classRegex = {
                { "(?:cva|clsx|cn|tw|statusClass)\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { ":class=[\"']([^\"']*)[\"']", "[\"'`]([^\"'`]*).*?[\"'`]" },
              },
            },
          },
        },
      }

      opts.servers.emmet_language_server = {
        filetypes = {
          "css",
          "eruby",
          "html",
          "javascriptreact",
          "less",
          "sass",
          "scss",
          "svelte",
          "typescriptreact",
          "vue",
        },
        init_options = {
          showSuggestionsAsSnippets = true,
          showExpandedAbbreviation = "always",
        },
      }
    end,
  },
}
