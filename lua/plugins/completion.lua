return {
  {
    "saghen/blink.cmp",
    version = "v1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        menu = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          draw = {
            treesitter = {},
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
              { "kind" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 150,
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          },
        },
      },
      fuzzy = {
        sorts = { "exact", "score", "sort_text" },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            fallbacks = { "buffer" },
            score_offset = 10,
            transform_items = function(_, items)
              -- Demote Tailwind variant modifiers (*:, not-[], first-letter:, etc.)
              -- so base utility classes (flex, bg-..., mt-...) appear first
              for _, item in ipairs(items) do
                if item.client_name == "tailwindcss" and item.sortText and item.sortText:sub(1, 1) == "-" then
                  item.sortText = "9" .. item.sortText:sub(2)
                end
              end
              return items
            end,
          },
          buffer = {
            score_offset = -5,
            min_keyword_length = 3,
          },
          snippets = {
            score_offset = 2,
            opts = {
              extended_filetypes = {
                dart = { "flutter" },
              },
            },
          },
        },
      },
    },
  },
}
