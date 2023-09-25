local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = actions.results_scrolling_up,
                ["<C-d>"] = actions.results_scrolling_down,
                -- use telescope only in insert mode
                ['<C-]>'] = actions.close,
                ['<ESC>'] = actions.close,
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
            hidden = false,
            no_ignore = true
        }
    }
}

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>fh', '<cmd>lua require("telescope.builtin").oldfiles()<CR>', opts)
vim.keymap.set('n', '<leader>fj', '<cmd>lua require("telescope.builtin").find_files()<CR>', opts)
vim.keymap.set('n', '<leader>fk', '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
vim.keymap.set('n', '<leader>fl', '<cmd>lua require("telescope.builtin").grep_string()<CR>', opts)
vim.keymap.set('n', '<leader>fi', '<cmd>lua require("telescope.builtin").git_bcommits()<CR>', opts)
vim.keymap.set('n', '<leader>fo', '<cmd>lua require("telescope.builtin").buffers()<CR>', opts)
