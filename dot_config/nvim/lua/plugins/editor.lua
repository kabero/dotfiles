return {
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup({})
        end
    },

    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },

    {
        "tpope/vim-endwise",
        event = "VeryLazy",
    },

    {
        "tpope/vim-sleuth",
        event = "BufReadPost",
    },

    {
        "mechatroner/rainbow_csv",
        ft = "csv",
        config = function()
            vim.g.disable_rainbow_hover = 1
            vim.g.rcsv_colorpairs = {
                { 'darkcyan',    'darkcyan' },
                { 'green',       'green' },
                { 'red',         'red' },
                { 'NONE',        'NONE' },
                { 'darkred',     'darkred' },
                { 'magenta',     'magenta' },
                { 'darkblue',    'darkblue' },
                { 'darkgreen',   'darkgreen' },
                { 'darkmagenta', 'darkmagenta' },
            }
        end
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        -- Renders markdown inline in the buffer (headings, lists, code blocks,
        -- tables, checkboxes). OFF when a buffer opens; toggle on demand with
        -- <leader>q via :Run (see init.lua). anti_conceal disabled so the
        -- cursor line stays rendered too, instead of revealing its raw
        -- markdown.
        opts = {
            enabled = false,
            anti_conceal = { enabled = false },
        },
    },
}
