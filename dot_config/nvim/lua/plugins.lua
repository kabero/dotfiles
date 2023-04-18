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
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } },
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            opt = true
        }
    }

    -- z-command for vim
    use 'nanotee/zoxide.vim'

    use {
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
            require("which-key").setup {}
        end
    }

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
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = { { "nvim-lua/plenary.nvim" }, { 'neovim/nvim-lspconfig' } },
        config = function()
            local null_ls = require("null-ls")
            local sources = {
                null_ls.builtins.diagnostics.rubocop,
                null_ls.builtins.formatting.rubocop,
            }
            null_ls.setup({ sources = sources, debug = true })
        end
    }

    -- Github copilot
    use 'github/copilot.vim'
end)
