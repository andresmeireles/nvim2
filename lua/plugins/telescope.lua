return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            width = 0.85,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          buffers = {
            show_all_buffers = true,
            sort_mru = true,
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
                ["<C-x>"] = actions.delete_buffer,
              },
              n = {
                ["d"] = actions.delete_buffer,
                ["dd"] = actions.delete_buffer,
                ["x"] = actions.delete_buffer,
              },
            },
          },
        },
      }
    end,
    keys = {
      {
        "<leader><space>",
        "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=false<cr>",
        desc = "Switch Open File / Buffer",
      },
      {
        "<leader>bb",
        "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=false<cr>",
        desc = "List Open Files (Buffers)",
      },
      {
        "<leader>bd",
        "<cmd>bdelete<cr>",
        desc = "Close Current File (Buffer)",
      },
      {
        "<leader>ff",
        "<cmd>Telescope find_files<cr>",
        desc = "Find File by Name",
      },
      {
        "<leader>fg",
        "<cmd>Telescope live_grep<cr>",
        desc = "Find Text on Files",
      },
      {
        "<leader>sf",
        "<cmd>Telescope find_files<cr>",
        desc = "Find File by Name",
      },
      {
        "<leader>sg",
        "<cmd>Telescope live_grep<cr>",
        desc = "Find Text on Files",
      },
    },
  },
}
