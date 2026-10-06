return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" },
  opts = {
    focus = true,
  },
  keys = {
    -- Primary diagnostics browsing goes through Telescope (fuzzy picker),
    -- NOT the Trouble panel.
    {
      "<leader>xx",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "Diagnostics (Workspace, Telescope)",
    },
    {
      "<leader>xX",
      function()
        require("telescope.builtin").diagnostics({ bufnr = 0 })
      end,
      desc = "Diagnostics (Buffer, Telescope)",
    },
    -- Trouble panel kept only as an optional, secondary view.
    {
      "<leader>xt",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble panel)",
    },
    {
      "<leader>xl",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
}
