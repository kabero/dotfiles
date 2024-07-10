local opts = { noremap = true, silent = true }

-- General
------------------------------------
vim.g.mapleader = " "

-- Normal
------------------------------------
vim.api.nvim_set_keymap("n", "j", "gj", opts)
vim.api.nvim_set_keymap("n", "k", "gk", opts)
vim.api.nvim_set_keymap("n", "gj", "j", opts)
vim.api.nvim_set_keymap("n", "gk", "k", opts)
vim.api.nvim_set_keymap("n", "]b", ":<c-u>bnext<CR>", opts)
vim.api.nvim_set_keymap("n", "[b", ":<c-u>bprev<CR>", opts)
vim.api.nvim_set_keymap("n", "]q", ":<c-u>cnext<CR>", opts)
vim.api.nvim_set_keymap("n", "[q", ":<c-u>cprev<CR>", opts)
vim.api.nvim_set_keymap("n", "<c-l>", ":<c-u>noh<CR><c-l>", opts)
vim.api.nvim_set_keymap("n", "<c-o>", "<c-o>zz", opts)
vim.api.nvim_set_keymap("n", "<c-i>", "<c-i>zz", opts)

-- Insert
------------------------------------

-- Visual
------------------------------------
vim.api.nvim_set_keymap("v", "j", "gj", opts)
vim.api.nvim_set_keymap("v", "k", "gk", opts)
vim.api.nvim_set_keymap("v", "gj", "j", opts)
vim.api.nvim_set_keymap("v", "gk", "k", opts)

-- Command
------------------------------------
vim.api.nvim_set_keymap("c", "<C-b>", "<Left>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-f>", "<Right>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-a>", "<Home>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-e>", "<End>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-d>", "<Del>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-h>", "<BS>", { noremap = true })
-- FIXME: The behavior when the cursor is a the beginning of a line
vim.api.nvim_set_keymap("c", "<C-k>", "<C-f>D<C-c><C-c>:<Up>", { noremap = true })
vim.api.nvim_set_keymap("c", "<M-BS>", "<c-w>", { noremap = true })

-- Terminal
------------------------------------
vim.cmd [[
    tnoremap <Esc> <C-\><C-n>
    tnoremap <c-[> <C-\><C-n>
]]
