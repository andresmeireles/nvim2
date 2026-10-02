return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lsp_cfg = false, -- use mason + nvim-lspconfig setup
      lsp_on_attach = false, -- use global LspAttach autocmd
      dap_debug = false, -- dap handled by nvim-dap and nvim-dap-go
      lsp_inlay_hints = {
        enable = false,
      },
    },
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
    keys = {
      { "<leader>gt", "<cmd>GoTest<cr>", ft = "go", desc = "Go Test (Package)" },
      { "<leader>gf", "<cmd>GoTestFunc<cr>", ft = "go", desc = "Go Test Function" },
      { "<leader>gc", "<cmd>GoCoverage<cr>", ft = "go", desc = "Go Coverage" },
      { "<leader>ga", "<cmd>GoAddTag<cr>", ft = "go", desc = "Add Struct Tags" },
      { "<leader>gr", "<cmd>GoRmTag<cr>", ft = "go", desc = "Remove Struct Tags" },
      { "<leader>ge", "<cmd>GoIfErr<cr>", ft = "go", desc = "Generate if err != nil" },
      { "<leader>gs", "<cmd>GoFillStruct<cr>", ft = "go", desc = "Fill Struct" },
      { "<leader>gi", "<cmd>GoImpl<cr>", ft = "go", desc = "Implement Interface" },
      { "<leader>gd", "<cmd>GoDoc<cr>", ft = "go", desc = "Go Doc" },
    },
  },
}
