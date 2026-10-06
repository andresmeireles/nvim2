return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  init = function()
    -- Neovim 0.12 compatibility fix:
    -- In Neovim 0.12, query predicates and directives can receive quantified captures
    -- as a table of nodes ({ TSNode }) while older queries and directives expect a single TSNode.
    -- This resolves: treesitter.lua:197: attempt to call method 'range' (a nil value)
    local orig_get_range = vim.treesitter.get_range
    vim.treesitter.get_range = function(node, source, metadata)
      if type(node) == "table" and node[1] then
        node = node[1]
      end
      return orig_get_range(node, source, metadata)
    end

    local orig_get_node_text = vim.treesitter.get_node_text
    vim.treesitter.get_node_text = function(node, source, opts)
      if type(node) == "table" and node[1] then
        node = node[1]
      end
      return orig_get_node_text(node, source, opts)
    end
  end,
  event = { "BufReadPost", "BufNewFile" },
  cmd = {
    "TSInstall",
    "TSUpdate",
    "TSUpdateSync",
    "TSInstallInfo",
  },
  opts = {
    ensure_installed = {
      "bash",
      "blade",
      "c",
      "css",
      "dart",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "php",
      "php_only",
      "phpdoc",
      "query",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    },
    sync_install = false,
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
