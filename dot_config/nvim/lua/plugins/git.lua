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
                "<leader>gg",
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
        opts = function()
            local actions = require("diffview.actions")
            -- Scroll the diff windows (not the list panel) while the cursor
            -- stays in the file/history panel. scroll_view targets the tallest
            -- diff window: +1 = one line down (<c-e>), -1 = one line up (<c-y>).
            local scroll_panel = {
                { "n", "<c-e>", actions.scroll_view(1),  { desc = "Scroll diff down (stay in panel)" } },
                { "n", "<c-y>", actions.scroll_view(-1), { desc = "Scroll diff up (stay in panel)" } },
            }
            return {
            enhanced_diff_hl = true,
            hooks = {
                -- Delta-style side-aware colours: repaint the OLD (left) window
                -- in the red family — removed lines, changed-line band, and the
                -- changed word all read as "this is going away" instead of the
                -- shared green Diff* groups. Groups defined in colors.lua.
                -- Only 2-pane layouts; the 3-way merge tool keeps its defaults.
                diff_buf_win_enter = function(_, winid, ctx)
                    if ctx.symbol == "a" and ctx.layout_name:match("^diff2") then
                        vim.wo[winid].winhl = table.concat({
                            "DiffAdd:DiffviewOldDelete",
                            "DiffChange:DiffviewOldChange",
                            "DiffText:DiffviewOldText",
                            "DiffDelete:DiffviewDiffDeleteDim",
                        }, ",")
                    end
                end,
            },
            view = {
                -- 3-way layout makes merge-conflict review legible.
                merge_tool = { layout = "diff3_mixed" },
            },
            keymaps = {
                -- `q` closes from the list panels (non-editable); the diff
                -- windows themselves are left alone so `q` keeps recording macros.
                file_panel = {
                    { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
                    unpack(scroll_panel),
                },
                file_history_panel = {
                    { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
                    unpack(scroll_panel),
                },
            },
            }
        end,
    },

    {
        -- Colorise merge-conflict regions in any buffer (git leaves the raw
        -- <<<<<<< ======= >>>>>>> markers uncoloured). Highlights ours/theirs/
        -- ancestor as distinct bands, jumps between conflicts, and resolves
        -- with one key. Colours match the diff palette (ours = green like an
        -- "add", theirs = blue, base = red).
        "akinsho/git-conflict.nvim",
        version = "*",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            default_mappings = false,   -- buffer-local maps wired below, only in conflicted buffers
            disable_diagnostics = false,
        },
        config = function(_, opts)
            require("git-conflict").setup(opts)

            -- Set the final highlight groups directly (rather than letting the
            -- plugin derive loud bands from a base colour). Keep it calm: the
            -- conflict-body REGIONS get only a faint tint so the code stays
            -- readable, and the marker LINES (<<<<<<< ||||||| ======= >>>>>>>)
            -- carry a clear, bold band that identifies ours/base/theirs. Run
            -- after setup() so this wins over the plugin's own defaults, and on
            -- every ColorScheme (registered after the plugin's hook → runs last).
            local function set_conflict_colors()
                -- region bodies: barely-there tint
                vim.api.nvim_set_hl(0, "GitConflictCurrent",  { bg = "#20271e" }) -- ours   (faint green)
                vim.api.nvim_set_hl(0, "GitConflictIncoming", { bg = "#1d2430" }) -- theirs (faint blue)
                vim.api.nvim_set_hl(0, "GitConflictAncestor", { bg = "#262021" }) -- base   (faint warm grey)
                -- marker lines: clear + bold, but not neon
                vim.api.nvim_set_hl(0, "GitConflictCurrentLabel",  { bg = "#38492f", fg = "#c5d9b8", bold = true })
                vim.api.nvim_set_hl(0, "GitConflictIncomingLabel", { bg = "#2c3a52", fg = "#b8c8e0", bold = true })
                vim.api.nvim_set_hl(0, "GitConflictAncestorLabel", { bg = "#43383a", fg = "#d6c2c2", bold = true })
                -- floating key-hint shown above each conflict
                vim.api.nvim_set_hl(0, "GitConflictHint",    { fg = "#6f6f6f", italic = true })
                vim.api.nvim_set_hl(0, "GitConflictHintKey", { fg = "#e6c384", bold = true })
            end
            set_conflict_colors()
            vim.api.nvim_create_autocmd("ColorScheme", { callback = set_conflict_colors })

            -- Float a key-hint line above each conflict so the (rarely-used)
            -- resolution maps are right there when you need them. Re-scan the
            -- buffer for <<<<<<< markers and drop a virt_lines extmark above each.
            local hint_ns = vim.api.nvim_create_namespace("git_conflict_hints")
            local function place_hints(buf)
                if not vim.api.nvim_buf_is_valid(buf) then return end
                vim.api.nvim_buf_clear_namespace(buf, hint_ns, 0, -1)
                for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
                    if line:match("^<<<<<<<") then
                        vim.api.nvim_buf_set_extmark(buf, hint_ns, i - 1, 0, {
                            virt_lines_above = true,
                            virt_lines = { {
                                { "  ▌conflict  ", "GitConflictHint" },
                                { "co", "GitConflictHintKey" }, { " ours  ", "GitConflictHint" },
                                { "ct", "GitConflictHintKey" }, { " theirs  ", "GitConflictHint" },
                                { "cb", "GitConflictHintKey" }, { " both  ", "GitConflictHint" },
                                { "c0", "GitConflictHintKey" }, { " none    ", "GitConflictHint" },
                                { "]x [x", "GitConflictHintKey" }, { " move", "GitConflictHint" },
                            } },
                        })
                    end
                end
            end

            -- Maps live only while a buffer actually has conflicts, so co/ct/cb/c0
            -- never shadow anything in normal editing.
            vim.api.nvim_create_autocmd("User", {
                pattern = "GitConflictDetected",
                callback = function(ev)
                    local function map(lhs, plug, desc)
                        vim.keymap.set("n", lhs, plug, { buffer = ev.buf, silent = true, desc = desc })
                    end
                    map("co", "<Plug>(git-conflict-ours)",        "Conflict: take ours")
                    map("ct", "<Plug>(git-conflict-theirs)",      "Conflict: take theirs")
                    map("cb", "<Plug>(git-conflict-both)",        "Conflict: take both")
                    map("c0", "<Plug>(git-conflict-none)",        "Conflict: take none")
                    map("]x", "<Plug>(git-conflict-next-conflict)", "Conflict: next")
                    map("[x", "<Plug>(git-conflict-prev-conflict)", "Conflict: prev")
                    place_hints(ev.buf)
                    -- keep the hints in sync as conflicts get resolved/edited
                    vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
                        buffer = ev.buf,
                        callback = function() place_hints(ev.buf) end,
                    })
                end,
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = "GitConflictResolved",
                callback = function(ev) place_hints(ev.buf) end,
            })
        end,
    },

    {
        "rhysd/committia.vim",
        ft = "gitcommit",
    },
}
