---@diagnostic disable: undefined-global
-- load configs
-----------------------------
require "options"
require "color"
require "keymap"
require "plugins"
-- require "lsp"

-- configs of plugins
-----------------------------
local opts = { noremap = true, silent = true }
-- require("nvim-tree").setup()

-- which-key
vim.api.nvim_set_keymap("n", "<leader>w", ":WhichKey<CR>", opts)

-- null_ls
-- local null_ls = require("null-ls")
-- local sources = {
--     null_ls.builtins.diagnostics.rubocop,
--     null_ls.builtins.formatting.rubocop,
-- }
-- null_ls.setup({
--     sources = sources,
--     debug = true,
-- })

-- nvim-tree
-- vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeToggle<CR>", opts)

-- other configs
-----------------------------
-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Restore last position of cursor
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    pattern = { '*' },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})
