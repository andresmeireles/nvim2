return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format Buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        php = function(bufnr)
          local file = vim.api.nvim_buf_get_name(bufnr)
          local root = vim.fs.root(file, { "composer.json", ".git" })
          if vim.fs.root(file, { "artisan", "pint.json" })
            or (root and vim.fn.executable(root .. "/vendor/bin/pint") == 1) then
            return { "pint" }
          end
          return { "php_cs_fixer" }
        end,
        blade = { "blade-formatter" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      formatters = {
        pint = {
          cwd = function(self, ctx)
            return require("conform.util").root_file({ "pint.json", "composer.json", "artisan" })(self, ctx)
          end,
        },
      },
      format_on_save = function(bufnr)
        -- Keep Go files formatting handled by the dedicated autocmd in lsp.lua
        local ignore_filetypes = { "go" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        return {
          timeout_ms = vim.bo[bufnr].filetype == "php" and 3000 or 1000,
          lsp_format = "fallback",
        }
      end,
    },
  },
}
