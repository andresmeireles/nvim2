return {
  -- Autoclose parentheses, brackets, braces, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
      fast_wrap = {},
      enable_check_bracket_line = false,
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
    end,
  },

  -- Autoclose and autorename HTML, Vue, JSX, XML tags
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,          -- Auto close tags when typing >
        enable_rename = true,         -- Auto rename opening/closing tags together
        enable_close_on_slash = true, -- Auto close on trailing </
      },
    },
  },
}
