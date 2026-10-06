return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      vim.diagnostic.config({
        virtual_text = {
          spacing = 2,
          prefix = "●",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = has_blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

      vim.lsp.config("*", { capabilities = capabilities })

      for server, server_opts in pairs(opts.servers or {}) do
        local server_cfg = vim.deepcopy(server_opts)
        if server_cfg.setup then
          server_cfg.setup()
          server_cfg.setup = nil
        end
        server_cfg.capabilities = has_blink and blink.get_lsp_capabilities(server_cfg.capabilities)
          or vim.tbl_deep_extend("force", capabilities, server_cfg.capabilities or {})
        vim.lsp.config(server, server_cfg)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(event)
          local map_opts = { buffer = event.buf, silent = true }

          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", map_opts, { desc = "Hover Documentation" }))
          vim.keymap.set("n", "gd", function()
            local ok, builtin = pcall(require, "telescope.builtin")
            if ok then
              builtin.lsp_definitions({ reuse_win = true })
            else
              vim.lsp.buf.definition()
            end
          end, vim.tbl_extend("force", map_opts, { desc = "Go to Definition" }))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", map_opts, { desc = "Go to Declaration" }))
          vim.keymap.set("n", "gi", function()
            local ok, builtin = pcall(require, "telescope.builtin")
            if ok then
              builtin.lsp_implementations({ reuse_win = true })
            else
              vim.lsp.buf.implementation()
            end
          end, vim.tbl_extend("force", map_opts, { desc = "Go to Implementation" }))
          -- Telescope LSP navigation (preserves the 'gr' prefix menu for gra, grn, gri, grr, grt)
          vim.keymap.set("n", "grr", function()
            local ok, builtin = pcall(require, "telescope.builtin")
            if ok then
              builtin.lsp_references({ include_declaration = false })
            else
              vim.lsp.buf.references()
            end
          end, vim.tbl_extend("force", map_opts, { desc = "References / Usages (Telescope)" }))
          vim.keymap.set("n", "gri", function()
            local ok, builtin = pcall(require, "telescope.builtin")
            if ok then
              builtin.lsp_implementations({ reuse_win = true })
            else
              vim.lsp.buf.implementation()
            end
          end, vim.tbl_extend("force", map_opts, { desc = "Implementation (Telescope)" }))
          vim.keymap.set("n", "grt", function()
            local ok, builtin = pcall(require, "telescope.builtin")
            if ok then
              builtin.lsp_type_definitions({ reuse_win = true })
            else
              vim.lsp.buf.type_definition()
            end
          end, vim.tbl_extend("force", map_opts, { desc = "Type Definition (Telescope)" }))
          vim.keymap.set("n", "<leader>lu", function()
            local ok, builtin = pcall(require, "telescope.builtin")
            if ok then
              builtin.lsp_references({ include_declaration = false })
            else
              vim.lsp.buf.references()
            end
          end, vim.tbl_extend("force", map_opts, { desc = "Usages / References (Telescope)" }))
          vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, vim.tbl_extend("force", map_opts, { desc = "Signature Documentation" }))
          vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", map_opts, { desc = "Code Action" }))
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", map_opts, { desc = "Rename Symbol" }))
          vim.keymap.set({ "n", "v" }, "<leader>lf", function()
            local ok, conform = pcall(require, "conform")
            if ok then
              conform.format({ async = true, lsp_format = "fallback" })
            else
              vim.lsp.buf.format({ async = true })
            end
          end, vim.tbl_extend("force", map_opts, { desc = "Format Buffer" }))
          vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", map_opts, { desc = "Line Diagnostics" }))
          vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, vim.tbl_extend("force", map_opts, { desc = "Diagnostics List" }))
          vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, vim.tbl_extend("force", map_opts, { desc = "Previous Diagnostic" }))
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, vim.tbl_extend("force", map_opts, { desc = "Next Diagnostic" }))
        end,
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonUpdate",
    },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs({ "prettier", "pint", "php-cs-fixer", "blade-formatter" }) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    cmd = {
      "LspInstall",
      "LspUninstall",
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = function(_, opts)
      local lsp_plugin = require("lazy.core.config").plugins["nvim-lspconfig"]
      local lsp_opts = require("lazy.core.plugin").values(lsp_plugin, "opts", false) or {}
      local servers = vim.tbl_keys(lsp_opts.servers or {})
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, servers)
      opts.automatic_enable = true
    end,
  },
}
