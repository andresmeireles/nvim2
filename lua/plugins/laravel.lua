local function action(callback)
  return function()
    local app = require("config.php").laravel()
    if app then
      callback(app)
    end
  end
end

return {
  "adalessa/laravel.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "nvim-telescope/telescope.nvim",
    "saghen/blink.cmp",
  },
  ft = { "php", "blade" },
  event = { "BufEnter composer.json" },
  cmd = { "Laravel" },
  opts = {
    features = { pickers = { provider = "telescope" } },
    -- Phpantom already understands Eloquent; extra generated LSP stubs are unnecessary.
    eloquent_generate_doc_blocks = false,
    extensions = {
      completion = { enable = false }, -- Phpantom provides Laravel and Blade completion.
    },
  },
  keys = {
    { "<leader>aa", action(function(app) app.pickers.artisan() end), desc = "Laravel: Artisan Commands" },
    { "<leader>ar", action(function(app) app.pickers.routes() end), desc = "Laravel: Routes" },
    { "<leader>am", action(function(app) app.pickers.make() end), desc = "Laravel: Generate Class" },
    { "<leader>af", action(function(app) app.pickers.resources() end), desc = "Laravel: Project Resources" },
    { "<leader>ac", action(function(app) app.pickers.composer() end), desc = "Laravel: Composer Commands" },
    { "<leader>at", action(function(app) app.commands.run("tinker:open") end), desc = "Laravel: Tinker" },
    { "<leader>av", action(function(app) app.commands.run("view:finder") end), desc = "Laravel: Find View / Usages" },
    { "<leader>ae", action(function(app) app.commands.run("env:configure") end), desc = "Laravel: Configure Sail / Herd / Local" },
  },
}
