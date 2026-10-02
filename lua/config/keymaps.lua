-- Window navigation (Left, Down, Up, Right)
-- Works in Normal, Insert, and Terminal modes without conflicting with macOS shortcuts

local map = vim.keymap.set

-- Normal mode: Navigate splits using Ctrl + hjkl
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Insert mode: Navigate splits directly without leaving insert mode first
map("i", "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Go to Left Window" })
map("i", "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Go to Lower Window" })
map("i", "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Go to Upper Window" })
map("i", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Go to Right Window" })

-- Terminal mode: Navigate splits from terminal buffers
map("t", "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Go to Right Window" })

-- Save file (Ctrl-S and Command-S on macOS)
-- Normal mode: simple save
-- Insert mode: save and remain in insert mode
-- Visual mode: save and retain visual selection
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save File" })
map("i", "<C-s>", "<cmd>w<cr>", { desc = "Save File (Stay in Insert)" })
map("x", "<C-s>", "<cmd>w<cr>gv", { desc = "Save File (Stay in Visual)" })

if vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
  map("n", "<D-s>", "<cmd>w<cr>", { desc = "Save File (Cmd-S)" })
  map("i", "<D-s>", "<cmd>w<cr>", { desc = "Save File (Cmd-S)" })
  map("x", "<D-s>", "<cmd>w<cr>gv", { desc = "Save File (Cmd-S)" })
end

