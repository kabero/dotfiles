-- Reference
-- https://qiita.com/delphinus/items/8160d884d415d7425fcc

vim.cmd.packadd "packer.nvim"

local packer = require("packer")
packer.init({})
packer.startup(function()
    -- packer
    use 'wbthomason/packer.nvim'

    -- color schemes
    use 'Mofiqul/dracula.nvim'
    use 'EdenEast/nightfox.nvim'
    use 'cocopon/iceberg.vim'
    use 'ellisonleao/gruvbox.nvim'
    use 'habamax/vim-gruvbit'
    use 'sainnhe/gruvbox-material'

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
        tag = 'nightly'
    }
    use 'machakann/vim-sandwich'
    use 'jiangmiao/auto-pairs'
    use 'tpope/vim-commentary'
    use 'nvim-lua/plenary.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = [[:TSUpdate]]
    }
    use 'lewis6991/gitsigns.nvim'
    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup {
                'css',
                'javascript',
                html = {
                    mode = 'foreground'
                }
            }
        end
    }
    use 'folke/which-key.nvim'

    -- fuzzy finder
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } },
    }
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }

    -- light line
    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            opt = true
        }
    }

    -- z-command for vim
    use 'nanotee/zoxide.vim'


    -- lsp
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/vim-vsnip"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-emoji"
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = { { "nvim-lua/plenary.nvim" }, { 'neovim/nvim-lspconfig' } },
    }

    -- snippets
    use({
        "L3MON4D3/LuaSnip",
        tag = "v1.*",
        run = "make install_jsregexp"
    })

    -- Github copilot
    use 'github/copilot.vim'
end)
