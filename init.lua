-- Set leader key to space before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable default Space motion in normal and visual mode
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

require("config.options")
require("config.keymaps")
require("config.lazy")
