local opts = { noremap = true, silent = true }


-- General
vim.g.mapleader = " "

-- Normal
vim.api.nvim_set_keymap("n", "j", "gj", opts)
vim.api.nvim_set_keymap("n", "k", "gk", opts)
vim.api.nvim_set_keymap("n", "<leader>,", ":e $MYVIMRC<CR>", opts)

-- Insert

-- Visual
