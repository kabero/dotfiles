local opts = { noremap = true, silent = true }


-- General
vim.g.mapleader = " "

-- Normal
vim.api.nvim_set_keymap("n", "j", "gj", opts)
vim.api.nvim_set_keymap("n", "k", "gk", opts)
vim.api.nvim_set_keymap("n", "<leader>,", ":e $MYVIMRC<CR>", opts)

-- Insert

-- Visual

-- Plugins
-----------------------------------------

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>r', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>g', builtin.git_bcommits, {})
vim.keymap.set('n', '<leader>h', builtin.oldfiles, {})
