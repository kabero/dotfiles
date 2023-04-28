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

    {
        "folke/which-key.nvim",
        config = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 300
            require("which-key").setup({})
            vim.api.nvim_set_keymap("n", "<leader>w", ":WhichKey<CR>", { noremap = true, silent = true })
        end
    },

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

            vim.keymap.set('n', '<leader>f', '<cmd>lua require("telescope.builtin").find_files()<CR>', {})
            vim.keymap.set('n', '<leader>r', '<cmd>lua require("telescope.builtin").live_grep()<CR>', {})
            vim.keymap.set('n', '<leader>b', '<cmd>lua require("telescope.builtin").buffers()<CR>', {})
            vim.keymap.set('n', '<leader>g', '<cmd>lua require("telescope.builtin").git_bcommits()<CR>', {})
            vim.keymap.set('n', '<leader>h', '<cmd>lua require("telescope.builtin").oldfiles()<CR>', {})
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
            'nvim-tree/nvim-web-devicons',
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
                    lualine_c = { { 'filename', file_status = true, path = 1 } },
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


    { 'jiangmiao/auto-pairs', lazy = false },

    {
        'windwp/nvim-ts-autotag',
        lazy = false,
        config = function()
            require('nvim-ts-autotag').setup({
                filetypes = { 'html', 'xml' }
            })
        end
    },

    { 'tpope/vim-commentary', lazy = false },

    {
        'akinsho/bufferline.nvim',
        lazy = false,
        version = '*',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('bufferline').setup {}
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    'bash',
                    'c',
                    'cpp',
                    'css',
                    'dockerfile',
                    'gitcommit',
                    'gitignore',
                    'go',
                    'graphql',
                    'html',
                    'javascript',
                    'jq',
                    'json',
                    'json5',
                    'lua',
                    'markdown',
                    'markdown_inline',
                    'php',
                    'python',
                    'regex',
                    'ruby',
                    'rust',
                    'scala',
                    'scss',
                    'sql',
                    'tsx',
                    'typescript',
                    'vim',
                    'vue',
                    'yaml',
                    'zig',
                },
                highlight = {
                    enable = true,
                }
            }
        end
    },

    {
        'j-hui/fidget.nvim',
        lazy = false,
        config = function()
            require('fidget').setup({})
        end
    },

    {
        'lewis6991/gitsigns.nvim',
        lazy = false,
        config = function()
            require("gitsigns").setup()
        end
    },

    { 'nanotee/zoxide.vim',    event = 'InsertEnter, CmdlineEnter' },

    { 'neovim/nvim-lspconfig', event = 'InsertEnter' },

    {
        'williamboman/mason.nvim',
        lazy = false,
        build = ":MasonUpdate",
        config = function()
            local mason = require('mason')
            mason.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "→",
                        package_uninstalled = "✗"
                    }
                }
            })
        end
    },

    {
        'williamboman/mason-lspconfig.nvim',
        lazy = false,
        config = function()
            local mason_lspconfig = require('mason-lspconfig')
            local nvim_lsp = require('lspconfig')
            mason_lspconfig.setup_handlers({ function(server)
                local opts = {}
                opts.on_attach = function(_, bufnr)
                    -- Keybindings
                    local bufopts = { noremap = true, silent = true, buffer = bufnr }
                    vim.keymap.set('n', 'gl', function() vim.lsp.buf.format { async = true } end, bufopts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
                    vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
                    vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
                end
                nvim_lsp[server].setup(opts)
            end })

            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
            )
        end
    },

    {
        'glepnir/lspsaga.nvim',
        event = 'LspAttach',
        config = function()
            require('lspsaga').setup({
                symbol_in_winbar = {
                    enable = false,
                },
                ui = {
                    code_action = "",
                }
            })

            vim.keymap.set('n', 'gr', '<cmd>Lspsaga rename<CR>')
            vim.keymap.set('n', 'ga', '<cmd>Lspsaga code_action<CR>')
            vim.keymap.set('n', 'gp', '<cmd>Lspsaga peek_definition<CR>')
            vim.keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>')
            vim.keymap.set('n', 'g]', '<cmd>Lspsaga diagnostic_jump_next<CR>')
            vim.keymap.set('n', 'g[', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
            vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
            vim.keymap.set('n', '<leader>o', '<cmd>Lspsaga outline<CR>')
            vim.keymap.set('n', '<leader>d', '<cmd>Lspsaga show_buf_diagnostics<CR>')
            vim.keymap.set('n', '<leader>D', '<cmd>Lspsaga show_workspace_diagnostics<CR>')
            vim.keymap.set({ 'n', 't' }, '<C-j>', '<cmd>Lspsaga term_toggle<CR>')
        end,
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
            { 'nvim-treesitter/nvim-treesitter' },
        },
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-nvim-lsp-document-symbol',
            'onsails/lspkind.nvim',
            'hrsh7th/vim-vsnip',
            'onsails/lspkind.nvim',
        },
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                window = {
                    completion = cmp.config.window.bordered({
                        border = 'single'
                    }),
                    documentation = cmp.config.window.bordered({
                        border = 'single'
                    }),
                },
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    { name = "path" },
                    { name = "nvim_lsp_signature_help" },
                }, {
                    { name = "buffer", keyword_length = 2 }
                }),
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-f>"] = cmp.mapping.confirm { select = true },
                    ["<CR>"] = cmp.mapping.confirm { select = true },
                }),
                experimental = {
                    ghost_text = true,
                },
                formatting = {
                    format = require('lspkind').cmp_format({
                        mode = 'symbol',
                        maxwidth = 50,
                        ellipsis_char = '...',
                    })
                }
            })

            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp_document_symbol' }
                }, {
                    { name = 'buffer' }
                })
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline", keyword_length = 2 },
                }),
            })
        end
    },

    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            local sources = {
                null_ls.builtins.diagnostics.rubocop.with({
                    prefer_local = "bundle_bin",
                    condition = function(utils)
                        return utils.root_has_file({ ".rubocop.yml" })
                    end
                }),
                null_ls.builtins.formatting.rubocop.with({
                    prefer_local = "bundle_bin",
                    condition = function(utils)
                        return utils.root_has_file({ ".rubocop.yml" })
                    end
                }),
            }
            null_ls.setup({
                sources = sources,
                debug = true,
            })
        end
    },
})


-- -- snippets
-- use({
--     "L3MON4D3/LuaSnip",
--     tag = "v1.*",
--     run = "make install_jsregexp"
-- })
-- Github copilot
-- use 'github/copilot.vim'
