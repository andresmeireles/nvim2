return {
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>pt", function() require("config.php").test(false) end, desc = "PHP: Run Test Suite" },
    { "<leader>pf", function() require("config.php").test(true) end, desc = "PHP: Run Current Test File" },
  },
}
