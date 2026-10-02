return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "▔" },
        changedelete = { text = "░" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "▔" },
        changedelete = { text = "░" },
      },
      -- Inline blame settings (like VS Code GitLens)
      current_line_blame = false, -- Toggleable with <leader>gb
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 300,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "   <author>, <author_time:%R> • <summary>",
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, silent = true, desc = desc })
        end

        -- Navigation between changes (like VS Code changes / hunks)
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.nav_hunk("next")
          end)
          return "<Ignore>"
        end, "Next Git Change / Hunk")

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.nav_hunk("prev")
          end)
          return "<Ignore>"
        end, "Previous Git Change / Hunk")

        -- Actions & Blame
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Git: Toggle Inline Blame")
        map("n", "<leader>gB", function()
          gs.blame_line({ full = true })
        end, "Git: Blame Popup (Full Info)")
        map("n", "<leader>gp", gs.preview_hunk, "Git: Preview Change / Hunk")
        map("n", "<leader>gD", gs.diffthis, "Git: Diff File Against Index")
        map("n", "<leader>gS", gs.stage_hunk, "Git: Stage Current Hunk")
        map("n", "<leader>gU", gs.reset_hunk, "Git: Undo / Reset Hunk")

        -- Quick toggle alias under Toggle (<leader>t)
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle Inline Git Blame")
      end,
    },
  },
}
