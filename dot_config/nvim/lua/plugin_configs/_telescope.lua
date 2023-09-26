local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup {
    defaults = {
        mappings = {
            i = {
                -- scroll results
                -- ["<C-u>"] = actions.results_scrolling_up,
                -- ["<C-d>"] = actions.results_scrolling_down,

                -- scroll preview
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                -- open in split window
                ["<C-l>"] = actions.select_vertical,
                ["<C-j>"] = actions.select_horizontal,

                -- emacs-like mappings
                ["<C-b>"] = { "<left>", type = "command" },
                ["<C-f>"] = { "<right>", type = "command" },
                ["<C-a>"] = { "<c-o>0", type = "command" },
                ["<C-e>"] = { "<c-o>$", type = "command" },
                ["<C-k>"] = { "<c-o>D", type = "command" },
                ["<C-h>"] = { "<BS>", type = "command" },
                ["<M-BS>"] = { "<c-o>db<BS>", type = "command" },

                -- use telescope only in insert mode
                ['<C-]>'] = actions.close,
                ['<ESC>'] = actions.close,
                ['<C-c>'] = actions.close,
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
-- Finder
vim.keymap.set('n', '<leader>fh', ':Telescope oldfiles theme=ivy<CR>', opts)
vim.keymap.set('n', '<leader>fj', ':Telescope find_files theme=ivy<CR>', opts)
vim.keymap.set('n', '<leader>fk', ':Telescope live_grep theme=ivy<CR>', opts)
vim.keymap.set('n', '<leader>fl', ':Telescope grep_string theme=ivy<CR>', opts)
vim.keymap.set('n', '<leader>fi', ':Telescope jumplist theme=ivy show_line=false<CR>', opts)
vim.keymap.set('n', '<leader>fo', ':Telescope diagnostics theme=ivy<CR>', opts)
vim.keymap.set('n', '<leader>fb', ':Telescope buffers theme=ivy<CR>', opts)

-- Git
vim.keymap.set('n', '<leader>dj', ':Telescope git_commits theme=ivy<CR>', opts)
vim.keymap.set('n', '<leader>dk', ':Telescope git_bcommits theme=ivy<CR>', opts)
vim.keymap.set('n', '<leader>dl', ':Telescope git_status theme=ivy<CR>', opts)
