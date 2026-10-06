vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. " | setlocal expandtab< shiftwidth< softtabstop<"
