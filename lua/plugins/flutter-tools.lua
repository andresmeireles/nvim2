return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    debugger = {
      enabled = false, -- Disable DAP runner to avoid opening all DAP panels
    },
    dev_log = {
      enabled = true,
      open_cmd = "botright 14split", -- Open log as a clean bottom panel
      focus_on_open = false, -- Keep cursor focus in the editor
      win_opts = {
        statusline = "",
      },
    },
    lsp = {
      capabilities = function(config)
        local ok, blink = pcall(require, "blink.cmp")
        if ok then
          return vim.tbl_deep_extend("force", config, blink.get_lsp_capabilities())
        end
        return config
      end,
      init_options = {
        suggestFromUnimportedLibraries = true,
        closingLabels = true,
        outline = true,
        flutterOutline = true,
      },
      settings = {
        dart = {
          completeFunctionCalls = true,
          showTodos = true,
          updateImportsOnRename = true,
        },
      },
    },
  },
  config = function(_, opts)
    require("flutter-tools").setup(opts)

    -- Register Flutter & Dart keymaps for all Dart files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dart",
      group = vim.api.nvim_create_augroup("FlutterKeymaps", { clear = true }),
      callback = function(event)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
        end

        map("<leader>fs", "<cmd>FlutterRun<cr>", "Flutter: Start / Run")
        map("<leader>fr", "<cmd>FlutterReload<cr>", "Flutter: Hot Reload")
        map("<leader>fR", "<cmd>FlutterRestart<cr>", "Flutter: Hot Restart")
        map("<leader>fl", "<cmd>FlutterLogToggle<cr>", "Flutter: Toggle Dev Log")
        map("<leader>fq", "<cmd>FlutterQuit<cr>", "Flutter: Quit App")
        map("<leader>fe", "<cmd>FlutterEmulators<cr>", "Flutter: Emulators")
        map("<leader>fd", "<cmd>FlutterDevices<cr>", "Flutter: Devices")
      end,
    })

    -- Ensure Flutter Dev Log buffer never displays a statusline
    vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "FileType" }, {
      pattern = { "*__FLUTTER_DEV_LOG__*", "log" },
      callback = function(event)
        if vim.api.nvim_buf_get_name(event.buf):match("__FLUTTER_DEV_LOG__") then
          vim.opt_local.statusline = ""
        end
      end,
    })
  end,
}
