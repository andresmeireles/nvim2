return {
  -- Highlight matching HTML/XML/Vue tags and parentheses, and jump with %
  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      -- Highlight matching tag even when cursor is on tag attributes
      vim.g.matchup_matchparen_enabled = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_hi_surround_always = 1
      -- Show off-screen matching opening/closing tag in a popup or statusline
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      -- Override default matchit
      vim.g.matchup_override_vim_matchit = 1
    end,
  },
}
