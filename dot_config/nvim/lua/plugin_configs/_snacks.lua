---@type snacks.Config
local opts = {
    bigfile = { enabled = true, },
    dashboard = {
        enabled = true,
        preset = {
            keys = {},
        },
        sections = {
            { section = "header" },
            {
                icon = " ",
                desc = "Browse Repo",
                padding = 1,
                action = function()
                    Snacks.gitbrowse()
                end,
            },
            function()
                local in_git = Snacks.git.get_root() ~= nil
                local cmds = {
                    {
                        icon = " ",
                        title = "Open PRs",
                        cmd = "gh pr list -L 3",
                        action = function()
                            vim.fn.jobstart("gh pr list --web", { detach = true })
                        end,
                        height = 7,
                    },
                    {
                        title = "Open Issues",
                        cmd = "gh issue list -L 3",
                        action = function()
                            vim.fn.jobstart("gh issue list --web", { detach = true })
                        end,
                        icon = " ",
                        height = 7,
                    },
                }
                return vim.tbl_map(function(cmd)
                        return vim.tbl_extend("force", {
                            section = "terminal",
                            enabled = in_git,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        }, cmd)
                end, cmds)
            end,
            { section = "startup" },
        },
    },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = true },
    picker = {
        enabled = true,
        win = {
            input = {
                keys = {
                    ["<Esc>"] = { "close", mode = { "n", "i" } },
                    ["<c-[>"] = { "close", mode = { "n", "i" } },
                    ["<c-a>"] = { "<c-o>0", mode = { "i" }, expr = true, desc = "Beginning of line" },
                    ["<c-e>"] = { "<c-o>$", mode = { "i" }, expr = true, desc = "End of line" },
                    ["<c-k>"] = { "<c-o>D", mode = { "i" }, expr = true, desc = "Delete line" },
                    ["<c-f>"] = { "<Right>",  mode = { "i" }, expr = true, desc = "Move right" },
                    ["<c-b>"] = { "<Left>",   mode = { "i" }, expr = true, desc = "Move left" },
                },
            }
        }
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = {
        enabled = true,
        animate = {
            duration = { step = 5, total = 30 }
        },
    },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
}

local keys = {
    -- General
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    -- Search
    { "<leader>fj", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fh", function() Snacks.picker.smart() end, desc = "Recent" },
    { "<leader>fH", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fk", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    -- { "<leader>gs", function() Snacks.picker.git_diff({group=true}) end, desc = "Git Status" },
    { "<leader>gs", function() Snacks.picker.git_status({group=true}) end, desc = "Git Status" },
    { "<leader>gl", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>fl", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>fn", function() Snacks.picker.explorer() end, desc = "File Browser" },
    { "<leader>gg", function() Snacks.picker.git_grep() end, desc = "Git Grep" },
    -- LSP
    { "<leader>fi", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    {"<leader>fo", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    {
        "<leader>gd",
        function()
            vim.fn.system("git rev-parse --verify master")
            local is_master = vim.v.shell_error == 0
            Snacks.picker.git_diff({ base = is_master and "master" or "main" })
        end,
        desc = "Git Diff (master/main)",
    },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
}

return {
    opts = opts,
    keys = keys,
}
