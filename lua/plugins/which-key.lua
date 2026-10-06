return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    preset = "modern",
    win = {
      no_overlap = false,
    },
    spec = {
      { "<leader>e", desc = "Toggle Explorer" },
      { "<leader>E", desc = "Reveal File in Explorer" },
      { "<leader>d", group = "Debug" },
      { "<leader>g", group = "Git / Go" },
      { "<leader>l", group = "LSP" },
      { "<leader>t", group = "Terminal" },
      { "<leader>f", group = "Flutter / Find" },
      { "<leader>s", group = "Search / Find" },
      { "<leader>b", group = "Buffers" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
