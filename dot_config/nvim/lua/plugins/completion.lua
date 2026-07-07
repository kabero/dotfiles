return {
    {
        -- Replaces the nvim-cmp stack (cmp + 7 source/format plugins).
        -- Same keys as before: <C-p>/<C-n> select, <C-f> accept-first,
        -- <CR> accept-only-if-selected; <Tab> accept lives in the unified
        -- sidekick handler (tools.lua). LSP snippets expand via the built-in
        -- vim.snippet, matching the earlier vsnip removal.
        'saghen/blink.cmp',
        version = '1.*', -- prebuilt fuzzy-matcher binary
        event = { 'InsertEnter', 'CmdlineEnter' },
        opts = {
            keymap = {
                preset = 'none',
                ['<C-p>'] = { 'select_prev', 'fallback' },
                ['<C-n>'] = { 'select_next', 'fallback' },
                ['<C-f>'] = { 'select_and_accept', 'fallback' },
                ['<CR>']  = { 'accept', 'fallback' },
            },
            completion = {
                menu = { border = 'single' },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = { border = 'single' },
                },
                -- preselect=false keeps the old cmp semantics: <CR> is a plain
                -- newline unless an item was explicitly selected.
                list = { selection = { preselect = false, auto_insert = true } },
            },
            -- Built-in signature help replaces lsp_signature.nvim.
            signature = { enabled = true, window = { border = 'single' } },
            sources = {
                default = { 'lsp', 'path', 'buffer' },
                providers = {
                    buffer = { min_keyword_length = 2 },
                },
            },
            cmdline = {
                keymap = { preset = 'cmdline' },
                completion = { menu = { auto_show = true } },
            },
            fuzzy = { implementation = 'prefer_rust_with_warning' },
        },
        opts_extend = { 'sources.default' },
    },
}
