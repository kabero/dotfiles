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
        keys = {
            {
                "<leader>gv",
                function()
                    -- Toggle: review uncommitted working-tree changes.
                    if require("diffview.lib").get_current_view() then
                        vim.cmd("DiffviewClose")
                    else
                        vim.cmd("DiffviewOpen")
                    end
                end,
                desc = "Diffview: working tree (toggle)",
            },
            {
                "<leader>gV",
                function()
                    if require("diffview.lib").get_current_view() then
                        vim.cmd("DiffviewClose")
                        return
                    end
                    -- PR-style review: merge-base diff of this branch vs the
                    -- default branch (master/main, matching <leader>gd).
                    vim.fn.system("git rev-parse --verify master")
                    local base = vim.v.shell_error == 0 and "master" or "main"
                    vim.cmd("DiffviewOpen " .. base .. "...HEAD --imply-local")
                end,
                desc = "Diffview: branch vs master/main (PR review)",
            },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: current file history" },
            { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",   desc = "Diffview: repo history" },
        },
        opts = {
            enhanced_diff_hl = true,
            view = {
                -- 3-way layout makes merge-conflict review legible.
                merge_tool = { layout = "diff3_mixed" },
            },
            keymaps = {
                -- `q` closes from the list panels (non-editable); the diff
                -- windows themselves are left alone so `q` keeps recording macros.
                file_panel = {
                    { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
                },
                file_history_panel = {
                    { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
                },
            },
        },
    },

    {
        "rhysd/committia.vim",
        ft = "gitcommit",
    },
}
