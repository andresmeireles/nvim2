return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  opts = {
    flavour = "auto",
    background = {
      light = "latte",
      dark = "mocha",
    },
    term_colors = true,
    transparent_background = true,
    float = {
      transparent = true,
    },
    integrations = {
      dap = true,
      dap_ui = true,
      lsp_trouble = true,
      mason = true,
      native_lsp = {
        enabled = true,
      },
      nvimtree = true,
      treesitter = true,
      which_key = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")

    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      group = vim.api.nvim_create_augroup("UserColorScheme", { clear = true }),
      callback = function()
        vim.schedule(function()
          vim.cmd.colorscheme("catppuccin")
        end)
      end,
    })
  end,
}
