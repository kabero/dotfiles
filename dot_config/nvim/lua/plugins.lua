-- Reference
-- https://qiita.com/delphinus/items/8160d884d415d7425fcc

vim.cmd.packadd "packer.nvim"

require("packer").startup(function()
    -- color schemes
    use 'Mofiqul/dracula.nvim'
    use 'EdenEast/nightfox.nvim'

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
        tag = 'nightly'
    }

    use 'machakann/vim-sandwich'

    use 'wbthomason/packer.nvim'

    use 'jiangmiao/auto-pairs'

    use 'tpope/vim-commentary'

    use 'nvim-lua/plenary.nvim'

    use { 
        'nvim-treesitter/nvim-treesitter',
        run = [[:TSUpdate]] 
    }

    use {
        'lewis6991/gitsigns.nvim',
        tag = 'release'
    }

    -- fzf
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'


    -- z-command for vim
    use 'nanotee/zoxide.vim'

    use {
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
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
    -- use "hrsh7th/cmp-path"
    -- use "hrsh7th/cmp-buffer"
    -- use "hrsh7th/cmp-cmdline"
end)
