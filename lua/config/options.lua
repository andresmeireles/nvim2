-- Hide command bar on bottom (0 height)
vim.opt.cmdheight = 0

-- Suppress non-essential messages to prevent "Press ENTER" prompts/freezes with cmdheight = 0
vim.opt.shortmess:append({ c = true, s = true, S = true, F = true, W = true, I = true })

-- Hide default showmode (lualine handles code buffers; terminal statusline handles terminal)
vim.opt.showmode = false

-- Dynamically toggle cmdheight during macro recording to prevent hit-enter hangs
local cmdheight_macro_group = vim.api.nvim_create_augroup("CmdHeightMacro", { clear = true })
vim.api.nvim_create_autocmd("RecordingEnter", {
  group = cmdheight_macro_group,
  callback = function()
    vim.opt.cmdheight = 1
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  group = cmdheight_macro_group,
  callback = function()
    vim.defer_fn(function()
      vim.opt.cmdheight = 0
    end, 50)
  end,
})

-- show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Reserve a fixed gutter so Git/debug signs never shift the code horizontally.
vim.opt.signcolumn = "yes"

-- completion options
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- sync yank/paste with the system clipboard
-- yanking in neovim copies to the OS clipboard, and `p` pastes from it
vim.opt.clipboard = "unnamedplus"
