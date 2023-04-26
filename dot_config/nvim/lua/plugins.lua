local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight-night]])
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
    },

    { "folke/which-key.nvim", lazy = false},

    { 
        "nvim-telescope/telescope.nvim", 
        cmd = 'Telescope',
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require('telescope').setup {
                defaults = {
                    mappings = {
                        i = {
                            ['<C-u>'] = false,
                            ['<C-d>'] = false,
                        },
                    },
                    layout_strategy = "horizontal",
                    layout_config = { prompt_position = "top" },
                    sorting_strategy = "ascending",
                    winblend = 0,
                },
                pickers = {
                    find_files = {
                        hidden = true
                    }
                }
            }

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>f', builtin.find_files, {})
            vim.keymap.set('n', '<leader>r', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>b', builtin.buffers, {})
            vim.keymap.set('n', '<leader>g', builtin.git_bcommits, {})
            vim.keymap.set('n', '<leader>h', builtin.oldfiles, {})
        end
    },

    {
        "nvim-telescope/telescope-file-browser.nvim", 
        cmd = 'Telescope',
        lazy = false, 
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").load_extension "file_browser"
            vim.api.nvim_set_keymap(
                "n",
                "<space>n",
                ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
                { noremap = true }
            )
        end
    },


    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        dependencies = {
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'auto',
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    }
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            }
        end
    },


    {'jiangmiao/auto-pairs', event = 'InsertEnter'},

    {'tpope/vim-commentary', lazy = false},

    {'nvim-treesitter/nvim-treesitter', lazy = false},

    {
        'lewis6991/gitsigns.nvim', 
        lazy = false,
        -- event = 'BufNewFile, BufRead',
        config = function()
            require("gitsigns").setup()
        end
    },

    {'nanotee/zoxide.vim', lazy = false},
})


-- Reference
-- https://qiita.com/delphinus/items/8160d884d415d7425fcc

-- vim.cmd.packadd "packer.nvim"
-- 
-- local packer = require("packer")
-- packer.init({})
-- packer.startup(function()
--     -- -- packer
--     use 'wbthomason/packer.nvim'
-- 
--     -- -- color schemes
--     -- use 'Mofiqul/dracula.nvim'
--     -- use 'EdenEast/nightfox.nvim'
--     -- use 'cocopon/iceberg.vim'
--     -- use 'ellisonleao/gruvbox.nvim'
--     -- use 'habamax/vim-gruvbit'
--     -- use 'sainnhe/gruvbox-material'
--     -- use 'folke/tokyonight.nvim'

--     -- -- lsp
--     -- use 'neovim/nvim-lspconfig'
--     -- use 'williamboman/mason.nvim'
--     -- use 'williamboman/mason-lspconfig.nvim'
--     -- use "hrsh7th/nvim-cmp"
--     -- use "hrsh7th/cmp-nvim-lsp"
--     -- use "hrsh7th/vim-vsnip"
--     -- use "hrsh7th/cmp-path"
--     -- use "hrsh7th/cmp-buffer"
--     -- use "hrsh7th/cmp-cmdline"
--     -- use "hrsh7th/cmp-emoji"
--     -- use {
--     --     'jose-elias-alvarez/null-ls.nvim',
--     --     requires = { { "nvim-lua/plenary.nvim" }, { 'neovim/nvim-lspconfig' } },
--     -- }
-- 
--     -- -- snippets
--     -- use({
--     --     "L3MON4D3/LuaSnip",
--     --     tag = "v1.*",
--     --     run = "make install_jsregexp"
--     -- })
-- 
--     -- Github copilot
--     -- use 'github/copilot.vim'
-- end)
