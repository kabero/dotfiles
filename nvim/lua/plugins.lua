-- Install Packer when not installed
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
end

vim.cmd [[packadd packer.nvim]]
require 'packer'.startup(function(use)
    -- colorschemes
    use { 'nanotech/jellybeans.vim', opt = true }
    use "EdenEast/nightfox.nvim"


    -- quickrun
    use {
        'thinca/vim-quickrun',
        setup = function()
            vim.cmd [[let g:quickrun_config = {}]]
            vim.cmd [[ let g:quickrun_config._ = { 'outputter/error/success': 'buffer', 'outputter/error/error': 'quickfix', 'outputter/buffer/close_on_empty': 1, 'runner': 'vimproc', 'runner/vimproc/updatetime': 50, 'hook/time/enable': 1 }]]
            vim.cmd [[let g:quickrun_config.python = {'command': expand('~/.pyenv/shims/python'), 'cmdopt': '-u'}]]
            vim.cmd [[let g:quickrun_config.rust = {'command': "cargo run"}]]
            vim.api.nvim_set_keymap("n", "<leader>q", ":QuickRun<CR>", { noremap = false, silent = true })
            vim.cmd [[au FileType qf nnoremap <silent><buffer>q :quit<CR>]]
        end,
    }

    -- vimproc
    use { 'Shougo/vimproc.vim', run = 'make' }

    -- commenting
    use {
        'tomtom/tcomment_vim',
        setup = function()
            vim.opt.signcolumn = 'yes'
        end,
    }

    -- vim surround
    use 'tpope/vim-surround'


    -- Auto close parentheses
    use {
        'cohama/lexima.vim',
        setup = function()
            vim.api.nvim_set_keymap("i", "<c-h>", "<BS>", { noremap = false, silent = true })
            vim.api.nvim_set_keymap("c", "<c-h>", "<BS>", { noremap = false, silent = true })
        end,
    }

    -- Git
    use {
        'airblade/vim-gitgutter',
        setup = function()
            vim.opt.signcolumn = 'yes'
            vim.cmd [[let g:gitgutter_map_keys = 0]]
        end,
    }

    -- fugitive
    use 'tpope/vim-fugitive'

    -- treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = [[:TSUpdate]] }

    -- make brackets colorful
    use {
        'frazrepo/vim-rainbow',
        setup = function()
            vim.cmd [[let g:rainbow_active = 1]]
        end,
    }

    -- snippet
    use {
        'SirVer/ultisnips',
        setup = function()
            -- vim.cmd [[let g:UltiSnipsSnippetsDir = "~/.config/nvim/ultisnips/UltiSnips"]]
            vim.cmd [[let g:UltiSnipsEditSplit = "vertical"]]
            vim.api.nvim_set_keymap("n", "<leader>s", ":UltiSnipsEdit<CR>", { noremap = true, silent = true })
        end,
    }

    -- vim wrapper 4 zoxide
    use 'nanotee/zoxide.vim'


    -- fzf
    use 'junegunn/fzf'
    use {
        'junegunn/fzf.vim',
        setup = function()
            vim.api.nvim_set_keymap("n", "<leader>f", ":Files<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>h", ":History<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>g", ":Commit<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>b", ":Buffers<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>r", ":Rg<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>:", ":History:<CR>", { noremap = true, silent = true })
        end,
    }


    -- Rust
    use {
        'rust-lang/rust.vim',
        setup = function()
            vim.cmd [[ let g:rustfmt_autosave = 1 ]]
        end,
    }


    -- lsp
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"


    -- nvim-cmp
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/vim-vsnip"
    use {
        "quangnguyen30192/cmp-nvim-ultisnips",
        config = function()
            require("cmp_nvim_ultisnips").setup {}
        end,
    }

    -- startup-time
    use "dstein64/vim-startuptime"


    if packer_bootstrap then
        require("packer").sync()
    end
end)
