return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" },
  opts = {
    focus = true,
  },
  keys = {
    -- Browse diagnostics through Telescope.
    {
      "<leader>xx",
      function()
        require("telescope.builtin").diagnostics({ bufnr = 0 })
      end,
      desc = "Diagnostics (Buffer, Telescope)",
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
