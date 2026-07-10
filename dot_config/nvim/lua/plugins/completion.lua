return {
    {
        -- Replaces the nvim-cmp stack (cmp + 7 source/format plugins).
        -- Same keys as before: <C-p>/<C-n> select, <C-f> accept-first,
        -- <CR> accept-only-if-selected; <Tab> accept lives in the keys
        -- handler below. LSP snippets expand via the built-in vim.snippet,
        -- matching the earlier vsnip removal.
        'saghen/blink.cmp',
        version = '1.*', -- prebuilt fuzzy-matcher binary
        event = { 'InsertEnter', 'CmdlineEnter' },
        keys = {
            {
                "<tab>",
                function()
                    -- Single owner of insert-mode <Tab>: accept a visible
                    -- blink.cmp menu, then snippet-placeholder jump, else a
                    -- literal <Tab>. (blink's keymap deliberately leaves <Tab>
                    -- unbound; the snippet branch replaces nvim's default
                    -- <Tab> jump map, which this mapping shadows.)
                    local blink = package.loaded["blink.cmp"]
                    if blink and blink.is_visible() then
                        blink.select_and_accept()
                        return
                    end
                    if vim.snippet.active({ direction = 1 }) then
                        return "<cmd>lua vim.snippet.jump(1)<CR>"
                    end
                    return "<tab>"
                end,
                mode = "i",
                expr = true,
                desc = "Accept completion / snippet jump",
            },
        },
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
