return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = false,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = true,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal

    -- Lazygit floating terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "curved",
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      end,
      on_close = function(_)
        vim.cmd("startinsert!")
      end,
    })

    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end

    -- Python REPL terminal
    local python = Terminal:new({
      cmd = "python3",
      direction = "horizontal",
      on_open = function(term)
        vim.cmd("startinsert!")
      end,
    })

    function _PYTHON_TOGGLE()
      python:toggle()
    end

    -- Window navigation keymaps within terminal
    function _G.set_terminal_keymaps()
      local map_opts = { buffer = 0 }
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], map_opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], map_opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], map_opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], map_opts)
      vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], map_opts)
    end

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*",
      callback = function()
        set_terminal_keymaps()
        vim.opt_local.statusline = '%#ModeMsg# %{mode() ==# "t" ? "-- TERMINAL --" : "-- NORMAL --"} %*'
      end,
    })

    -- Always enter insert mode when entering a terminal pane
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
      pattern = "term://*",
      callback = function()
        vim.cmd("startinsert")
      end,
    })
  end,
  keys = {
    { "<C-\\>", "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle Terminal" },
    { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Default Terminal" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Floating Terminal" },
    { "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Horizontal Terminal Split" },
    { "<leader>tv", "<cmd>ToggleTerm size=60 direction=vertical<cr>", desc = "Vertical Terminal Split" },
    { "<leader>tg", function() _LAZYGIT_TOGGLE() end, desc = "Lazygit Terminal" },
    { "<leader>ta", "<cmd>ToggleTermToggleAll<cr>", desc = "Toggle All Terminals" },
    { "<leader>ts", "<cmd>ToggleTermSendCurrentLine<cr>", mode = "n", desc = "Send Line to Terminal" },
    { "<leader>ts", ":<C-u>'<,'>ToggleTermSendVisualSelection<CR>", mode = "x", desc = "Send Selection to Terminal" },
  },
}
