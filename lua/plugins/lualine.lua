return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",
      globalstatus = false,
      component_separators = { left = "│", right = "│" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {
          "toggleterm",
          "terminal",
          "NvimTree",
          "dap-repl",
          "dapui_console",
          "dapui_watches",
          "dapui_stacks",
          "dapui_breakpoints",
          "dapui_scopes",
          "dapui_hover",
          "log",
          "flutter_tools_log",
        },
        winbar = {
          "toggleterm",
          "terminal",
          "NvimTree",
          "dap-repl",
          "dapui_console",
          "dapui_watches",
          "dapui_stacks",
          "dapui_breakpoints",
          "dapui_scopes",
          "dapui_hover",
          "log",
          "flutter_tools_log",
        },
      },
      ignore_focus = {
        "dap-repl",
        "dapui_console",
        "dapui_watches",
        "dapui_stacks",
        "dapui_breakpoints",
        "dapui_scopes",
        "dapui_hover",
      },
      always_divide_middle = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        {
          "filename",
          path = 1, -- 1: Relative path
          symbols = {
            modified = "", -- Handled by dedicated colored component below
            readonly = "",
            unnamed = "[No Name]",
            newfile = "[New]",
          },
          padding = { left = 1, right = 0 },
          separator = "",
        },
        {
          function()
            return "●"
          end,
          cond = function()
            return vim.bo.modified
          end,
          color = { fg = "#fab387", gui = "bold" },
          padding = { left = 0, right = 1 },
        },
      },
      lualine_x = {
        -- Open buffers count indicator
        {
          function()
            local count = 0
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.api.nvim_buf_get_name(buf) ~= "" then
                count = count + 1
              end
            end
            return string.format("󰈔 %d open", count)
          end,
          color = { fg = "#9ece6a" },
        },
        -- Unsaved buffers count indicator (shows when any open file has unsaved changes)
        {
          function()
            local names = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.bo[buf].modified then
                local n = vim.api.nvim_buf_get_name(buf)
                local display_name = n ~= "" and vim.fs.basename(n) or "[No Name]"
                if #display_name > 15 then
                  display_name = display_name:sub(1, 14) .. "…"
                end
                table.insert(names, display_name)
              end
            end
            if #names == 0 then
              return ""
            end
            if #names == 1 then
              return string.format("● 1 unsaved (%s)", names[1])
            elseif #names == 2 then
              return string.format("● 2 unsaved (%s, %s)", names[1], names[2])
            else
              return string.format("● %d unsaved", #names)
            end
          end,
          cond = function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.bo[buf].modified then
                return true
              end
            end
            return false
          end,
          color = { fg = "#fab387" },
        },
        -- Flutter attached/connected device indicator
        {
          function()
            local name = nil

            -- 1. Try commands.current_device() from flutter-tools
            local ok, commands = pcall(require, "flutter-tools.commands")
            if ok and commands.current_device then
              local dev = commands.current_device()
              if type(dev) == "table" and dev.name and dev.name ~= "" then
                name = dev.name
              elseif type(dev) == "string" and dev ~= "" then
                name = dev
              end
            end

            -- 2. Try captured device name from dev_log filter or events
            if (not name or name == "") and vim.g.flutter_attached_device_name and vim.g.flutter_attached_device_name ~= "" then
              name = vim.g.flutter_attached_device_name
            end

            -- 3. Try flutter_tools_decorations
            if (not name or name == "") and vim.g.flutter_tools_decorations and vim.g.flutter_tools_decorations.device then
              local dev = vim.g.flutter_tools_decorations.device
              if type(dev) == "table" and dev.name and dev.name ~= "" then
                name = dev.name
              elseif type(dev) == "string" and dev ~= "" then
                name = dev
              end
            end

            return "📱 " .. (name or "Attached")
          end,
          cond = function()
            local is_flutter = vim.bo.filetype == "dart" or vim.fs.root(0, "pubspec.yaml") ~= nil
            if not is_flutter then
              return false
            end
            local ok, commands = pcall(require, "flutter-tools.commands")
            return ok and commands.is_running and commands.is_running()
          end,
          color = { fg = "#7dcfff" },
        },
        "encoding",
        "fileformat",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          path = 1,
          symbols = {
            modified = "●",
            readonly = "",
            unnamed = "[No Name]",
            newfile = "[New]",
          },
        },
      },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { "lazy" },
  },
  config = function(_, opts)
    require("lualine").setup(opts)

    -- Immediately refresh statusline when any buffer's modified status changes
    vim.api.nvim_create_autocmd("BufModifiedSet", {
      group = vim.api.nvim_create_augroup("LualineModifiedRefresh", { clear = true }),
      callback = function()
        pcall(require("lualine").refresh, { place = { "statusline" } })
      end,
    })
  end,
}
