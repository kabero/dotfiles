local api = vim.api
local opts = { noremap = true, silent = true }

-- General
vim.g.mapleader = " "

-- Normal
api.nvim_set_keymap("n", "j", "gj", opts)
api.nvim_set_keymap("n", "k", "gk", opts)
api.nvim_set_keymap("n", "<leader>,", ":e $MYVIMRC<CR>", opts)

-- Insert

-- Visual
