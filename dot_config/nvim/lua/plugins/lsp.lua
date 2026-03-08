return {
    {
        'neovim/nvim-lspconfig',
        event = 'VeryLazy',
    },

    {
        'williamboman/mason.nvim',
        version = '^2.0.0',
        event = "VeryLazy",
        config = function()
            require('mason').setup({
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
        version = '^2.0.0',
        event = "VeryLazy",
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig'
        },
        config = function()
            require('mason-lspconfig').setup {
                automatic_enable = true,
            }

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local bufnr = args.buf

                    if not client then return end

                    if client.name == "intelephense" then
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end

                    local bufopts = { noremap = true, silent = true, buffer = bufnr }
                    vim.keymap.set('n', 'gl', function()
                        vim.lsp.buf.format { async = true }
                    end, bufopts)
                end,
            })

            vim.diagnostic.config {
                virtual_text = {
                    format = function(diagnostic)
                        return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
                    end,
                },
                signs = true,
                underline = true,
            }

            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    update_in_insert = false,
                }
            )

            function ToggleDisplayDiagnostics()
                if ShowingDiagnostics == nil then
                    ShowingDiagnostics = true
                end

                if ShowingDiagnostics then
                    vim.diagnostic.disable()
                    print("Diagnostics disabled")
                else
                    vim.diagnostic.enable()
                    print("Diagnostics enabled")
                end
                ShowingDiagnostics = not ShowingDiagnostics
            end

            vim.keymap.set('n', '<leader>9', '<cmd>lua ToggleDisplayDiagnostics()<CR>', { noremap = true, silent = true })
        end
    },

    {
        'glepnir/lspsaga.nvim',
        event = 'LspAttach',
        dependencies = { { 'nvim-tree/nvim-web-devicons' }, { 'nvim-treesitter/nvim-treesitter' } },
        config = function()
            require('lspsaga').setup({
                lightbulb = {
                    virtual_text = false,
                },
                ui = {
                    code_action = "C"
                },
                symbol_in_winbar = {
                    enable = false,
                    hide_keyword = true,
                    show_file = false,
                    separator = " > ",
                },
                finder = {
                    max_height = 0.6,
                    default = 'tyd+ref+imp+def',
                    keys = {
                        toggle_or_open = '<CR>',
                        vsplit = 'v',
                        split = 's',
                        tabnew = 't',
                        tab = 'T',
                        quit = 'q',
                        close = '<Esc>',
                    },
                    methods = {
                        tyd = 'textDocument/typeDefinition',
                    },
                    layout = 'normal'
                }
            })

            vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc ++quiet<CR>')
            vim.keymap.set('n', 'ga', '<cmd>Lspsaga code_action<CR>')
            vim.keymap.set('n', 'gp', '<cmd>Lspsaga peek_definition<CR>')
            vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
            vim.keymap.set('n', 'gR', '<cmd>Lspsaga rename<CR>')
            vim.keymap.set('n', ']g', '<cmd>Lspsaga diagnostic_jump_next<CR>')
            vim.keymap.set('n', '[g', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
            vim.keymap.set('n', '<leader>0', '<cmd>Lspsaga outline<CR>')
        end,
    },

    {
        'nvimtools/none-ls.nvim',
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                diagnostics_format = "#{m} (#{s}: #{c})",
                sources            = {},
                debug              = false,
                defaults           = {},
                on_attach          = function(client)
                    client.server_capabilities.documentFormattingProvider = true
                    client.server_capabilities.documentRangeFormattingProvider = true
                end
            })
        end
    },

    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {},
    },

    {
        'j-hui/fidget.nvim',
        event = 'LspAttach',
        tag = 'legacy',
        config = function()
            require('fidget').setup({})
        end
    },
}
