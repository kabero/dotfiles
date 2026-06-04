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
-- Quick save (normal + insert), keeps cursor where it is
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>silent! write<CR>", { desc = "Save file" })
-- Quit all, with confirmation
vim.keymap.set("n", "<leader>Q", "<cmd>confirm qa<CR>", { desc = "Quit all (confirm)" })
-- Substitute the word under the cursor (non-silent: must show the cmdline)
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
    { noremap = true, desc = "Replace word under cursor" })

-- Insert
------------------------------------

-- Visual
------------------------------------
vim.api.nvim_set_keymap("v", "j", "gj", opts)
vim.api.nvim_set_keymap("v", "k", "gk", opts)
vim.api.nvim_set_keymap("v", "gj", "j", opts)
vim.api.nvim_set_keymap("v", "gk", "k", opts)
-- Paste over a selection without clobbering the register (x-mode only, so
-- select-mode literal replacement / snippet jumps are untouched)
vim.keymap.set("x", "p", '"_dP', { noremap = true, silent = true, desc = "Paste over selection (keep register)" })

-- Command
------------------------------------
vim.api.nvim_set_keymap("c", "<C-b>", "<Left>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-f>", "<Right>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-a>", "<Home>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-e>", "<End>", { noremap = false })
vim.api.nvim_set_keymap("c", "<C-d>", "<Del>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-h>", "<BS>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-k>", "<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>", { noremap = true })
vim.api.nvim_set_keymap("c", "<M-BS>", "<c-w>", { noremap = true })

-- Terminal
------------------------------------
vim.cmd [[
    tnoremap <Esc> <C-\><C-n>
    tnoremap <c-[> <C-\><C-n>
]]
