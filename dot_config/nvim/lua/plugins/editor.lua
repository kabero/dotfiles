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
        "phaazon/hop.nvim",
        event = 'VeryLazy',
        config = function()
            local hop = require('hop')
            hop.setup({
                create_hl_autocmd = false,
            })
            vim.api.nvim_set_keymap("n", "<leader>s", ":HopWordMW<CR>", { noremap = true, silent = true })

            vim.api.nvim_set_hl(0, 'HopNextKey', { fg = '#4cc9f0', bold = true, cterm = { bold = true, italic = true } })
            vim.api.nvim_set_hl(0, 'HopNextKey1', { fg = '#9d4edd', bold = true, cterm = { bold = true } })
            vim.api.nvim_set_hl(0, 'HopNextKey2', { fg = '#9d4edd', bold = true, cterm = { bold = true } })
            vim.api.nvim_set_hl(0, 'HopUnmatched', { fg = '#444444', cterm = { italic = true } })
        end
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
            "nvim-tree/nvim-web-devicons",
        },
        -- Renders markdown inline in the buffer (headings, lists, code blocks,
        -- tables, checkboxes). Toggle with <leader>q via jaq (see tools.lua).
        -- anti_conceal disabled so the cursor line stays rendered too, instead
        -- of revealing its raw markdown.
        opts = {
            anti_conceal = { enabled = false },
        },
    },
}
