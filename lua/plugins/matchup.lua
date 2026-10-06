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
    config = function(plugin)
      -- Matchup's newer queries can target a different grammar than the parsers
      -- pinned by nvim-treesitter's master branch. Keep upstream queries whenever
      -- they compile, and adapt only the incompatible PHP/Blade queries.
      for _, lang in ipairs({ "php", "blade" }) do
        local installed = pcall(vim.treesitter.language.add, lang)
        if installed and not pcall(vim.treesitter.query.get, lang, "matchup") then
          local path = plugin.dir .. "/after/queries/" .. lang .. "/matchup.scm"
          local query = table.concat(vim.fn.readfile(path), "\n")
          if lang == "php" then
            -- Older PHP grammars represent the closing tag as an anonymous token.
            query = query:gsub("%(php_end_tag%)", '"?>"')
          else
            -- Blade embeds HTML through injections; HTML query nodes belong to
            -- the injected HTML parser, not to the Blade grammar itself.
            query = query:gsub("; inherits: html\n", "")
          end
          if pcall(vim.treesitter.query.parse, lang, query) then
            vim.treesitter.query.set(lang, "matchup", query)
          end
        end
      end
    end,
  },
}
