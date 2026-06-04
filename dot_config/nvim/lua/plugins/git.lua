return {
    {
        'lewis6991/gitsigns.nvim',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('gitsigns').setup {
                on_attach = function(bufnr)
                    local function map(mode, lhs, rhs, opts)
                        opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
                        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
                    end

                    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
                    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })
                    map('n', '<leader>aj', '<cmd>Gitsigns preview_hunk<CR>', { desc = 'Preview hunk' })
                    map('n', '<leader>ak', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', { desc = 'Blame line' })
                    map('n', '<leader>al', '<cmd>lua require"gitsigns".diffthis(nil, {vertical=true})<CR>', { desc = 'Diff this (vertical)' })
                    map('n', '<leader>1', '<cmd>Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle line blame' })
                    map('n', '<leader>2', '<cmd>Gitsigns toggle_deleted<CR>', { desc = 'Toggle deleted' })
                end
            }
        end
    },

    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gclog", "Gdiffsplit", "Gread", "Gwrite", "Gedit", "Gblame", "GBrowse" },
        keys = {
            { "<leader>gc", ":0Gclog<CR>", silent = true, desc = "File git log (fugitive)" },
        },
    },

    {
        'sindrets/diffview.nvim',
        cmd = {
            "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory",
            "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh", "DiffviewLog",
        },
    },

    {
        "rhysd/committia.vim",
        ft = "gitcommit",
    },
}
