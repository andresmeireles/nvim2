return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = {
    "NvimTreeToggle",
    "NvimTreeFocus",
    "NvimTreeFindFile",
    "NvimTreeFindFileToggle",
  },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = {
    disable_netrw = true,
    hijack_netrw = true,
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    view = {
      width = 34,
      signcolumn = "yes",
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
      indent_markers = {
        enable = true,
      },
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
    },
    filters = {
      custom = { "^.git$" },
    },
    git = {
      enable = true,
      ignore = false,
    },
    actions = {
      open_file = {
        quit_on_open = false,
        resize_window = true,
      },
    },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")

      -- Load default nvim-tree mappings
      api.map.on_attach.default(bufnr)

      local function map_opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      local function resize(delta)
        local cur_w = vim.api.nvim_win_get_width(0)
        local new_w = cur_w + delta
        if new_w >= 15 then
          api.tree.resize({ relative = delta })
        end
      end

      -- Increase width (+ or = or <A-l> or <C-Right>)
      vim.keymap.set("n", "+", function() resize(5) end, map_opts("Increase Width"))
      vim.keymap.set("n", "=", function() resize(5) end, map_opts("Increase Width"))
      vim.keymap.set("n", "<A-l>", function() resize(5) end, map_opts("Increase Width"))
      vim.keymap.set("n", "<C-Right>", function() resize(5) end, map_opts("Increase Width"))

      -- Shrink width (_ or <A-h> or <C-Left>)
      vim.keymap.set("n", "_", function() resize(-5) end, map_opts("Shrink Width"))
      vim.keymap.set("n", "<A-h>", function() resize(-5) end, map_opts("Shrink Width"))
      vim.keymap.set("n", "<C-Left>", function() resize(-5) end, map_opts("Shrink Width"))

      -- Close or Quit when file tree is the last window
      local function close_or_quit()
        local wins = vim.api.nvim_tabpage_list_wins(0)
        local normal_wins = 0
        for _, win in ipairs(wins) do
          if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative == "" then
            normal_wins = normal_wins + 1
          end
        end
        if normal_wins <= 1 then
          if #vim.api.nvim_list_tabpages() > 1 then
            vim.cmd("tabclose")
          else
            vim.cmd("confirm quit")
          end
        else
          api.tree.close()
        end
      end

      vim.keymap.set("n", "q", close_or_quit, map_opts("Close or Quit"))

      -- Window navigation out of file tree
      vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>", map_opts("Go to Left Window"))
      vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>", map_opts("Go to Lower Window"))
      vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>", map_opts("Go to Upper Window"))
      vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>", map_opts("Go to Right Window"))
    end,
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)

    local api = require("nvim-tree.api")
    local view = require("nvim-tree.view")

    -- Reset panel size back to default whenever the tree is closed/hidden
    api.events.subscribe(api.events.Event.TreeClose, function()
      api.tree.resize()
    end)

    -- If the file tree is the last panel open when closed, close Vim instead of opening another panel
    local orig_close = view.close
    view.close = function(tabpage)
      local target_tab = tabpage or vim.api.nvim_get_current_tabpage()
      if not view.is_visible({ tabpage = target_tab }) then
        return
      end
      local wins = vim.api.nvim_tabpage_list_wins(target_tab)
      local normal_wins = 0
      for _, win in ipairs(wins) do
        if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative == "" then
          normal_wins = normal_wins + 1
        end
      end
      if normal_wins <= 1 then
        if #vim.api.nvim_list_tabpages() > 1 then
          vim.cmd("tabclose")
        else
          vim.cmd("confirm quit")
        end
        return
      end
      orig_close(tabpage)
    end
  end,
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Explorer" },
    { "<leader>E", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Reveal File in Explorer" },
  },
}
