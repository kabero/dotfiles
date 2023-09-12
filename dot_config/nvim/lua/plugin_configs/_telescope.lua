local telescope = require("telescope")
telescope.setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
                -- Only use in insert mode
                ['<C-]>'] = require("telescope.actions").close,
                ['<ESC>'] = require("telescope.actions").close,
            },
            n = { 
                ["q"] = require("telescope.actions").close 
            },
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        layout_config = { 
            horizontal = {
                prompt_position = "top" ,
                preview_width = 0.55,
                result_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.90,
            height = 0.85,
            preview_cutoff = 120,
        },
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        winblend = 0,
        border = {},
        set_env = { ["COLORTERM"] = "truecolor" },
    },
    pickers = {
        find_files = {
            hidden = true
        }
    }
}

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>f', '<cmd>lua require("telescope.builtin").find_files()<CR>', opts)
vim.keymap.set('n', '<leader>r', '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
vim.keymap.set('n', '<leader>b', '<cmd>lua require("telescope.builtin").buffers()<CR>', opts)
vim.keymap.set('n', '<leader>g', '<cmd>lua require("telescope.builtin").git_bcommits()<CR>', opts)
vim.keymap.set('n', '<leader>h', '<cmd>lua require("telescope.builtin").oldfiles()<CR>', opts)
vim.keymap.set('n', '<leader>k', "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>", opts)
vim.keymap.set('n', '<leader>l', "<Cmd>lua require('telescope').extensions.frecency.frecency({ workspace = 'CWD' })<CR>", opts)
