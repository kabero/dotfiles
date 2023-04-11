-- disable some standard plugins
-----------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- load configs
-----------------------------
require "options"
require "color"
require "keymap"
require "plugins"
require "lsp"

-- configs of plugins
-----------------------------
local opts = { noremap = true, silent = true }
require("nvim-tree").setup()
require("gitsigns").setup()

-- nvim-tree
vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeToggle<CR>", opts)

-- fzf
vim.api.nvim_set_keymap("n", "<leader>f", ":Files<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>g", ":GFiles<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>G", ":GFiles?<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>b", ":Buffers<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>h", ":History<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>r", ":Rg<CR>", opts)

-- whichkey
vim.api.nvim_set_keymap("n", "<leader>w", ":WhichKey<CR>", opts)


-- other configs
-----------------------------

-- open a quickfix window when executing a command whose name contains "grep"
vim.cmd([[autocmd QuickFixCmdPost *grep* cwindow]])
