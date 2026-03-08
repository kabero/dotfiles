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
                    map('n', '<leader>aj', '<cmd>Gitsigns preview_hunk<CR>')
                    map('n', '<leader>ak', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
                    map('n', '<leader>al', '<cmd>lua require"gitsigns".diffthis(nill, {vertical=true})<CR>')
                    map('n', '<leader>1', '<cmd>Gitsigns toggle_current_line_blame<CR>')
                    map('n', '<leader>2', '<cmd>Gitsigns toggle_deleted<CR>')
                end
            }
        end
    },

    {
        "tpope/vim-fugitive",
        event = 'VeryLazy',
        init = function()
            vim.api.nvim_set_keymap("n", "<leader>gc", ":0Gclog<CR>", { noremap = true, silent = true })
        end,
    },

    {
        'sindrets/diffview.nvim',
        event = 'VeryLazy',
    },

    {
        "rhysd/committia.vim",
        ft = "gitcommit",
    },
}
