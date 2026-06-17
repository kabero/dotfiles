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
            -- Broadcast nvim-cmp's completion capabilities (snippets,
            -- additionalTextEdits/auto-import, etc.) to every server that
            -- mason-lspconfig auto-enables. Without this, automatic_enable
            -- only advertises Neovim's default capabilities.
            vim.lsp.config('*', {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            })

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

                    -- Formatting is owned by conform.nvim (gl / :Format), which
                    -- falls back to the LSP — nothing to bind here.
                end,
            })

            vim.diagnostic.config {
                severity_sort = true,   -- errors sort above warnings in signs/virt_text
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    prefix = "●",
                    format = function(diagnostic)
                        -- Only append source/code when present, so diagnostics
                        -- without a code don't render "(nil: nil)".
                        local tag = diagnostic.source or ""
                        if diagnostic.code then
                            tag = tag ~= "" and (tag .. ": " .. diagnostic.code) or tostring(diagnostic.code)
                        end
                        return tag ~= "" and string.format("%s (%s)", diagnostic.message, tag) or diagnostic.message
                    end,
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN]  = "",
                        [vim.diagnostic.severity.INFO]  = "",
                        [vim.diagnostic.severity.HINT]  = "",
                    },
                },
                float = {
                    border = "rounded",
                    source = true,
                },
            }

            function ToggleDisplayDiagnostics()
                local enabled = vim.diagnostic.is_enabled()
                vim.diagnostic.enable(not enabled)
                print(enabled and "Diagnostics disabled" or "Diagnostics enabled")
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
        -- Formatting. none-ls is gone (its sources list was empty, so it did
        -- nothing). conform formats via `gl` / `:Format` and, crucially, takes
        -- NO global ft→formatter map: it falls back to the LSP everywhere, and
        -- each project registers its own formatters through exrc. Drop a
        -- `.nvim.lua` at a project root (exrc is enabled in options.lua):
        --     local cf = require("conform").formatters_by_ft
        --     cf.python     = { "ruff_format" }
        --     cf.javascript = { "prettierd" }
        --     cf.lua        = { "stylua" }
        -- The needed binaries are installed by mason-tool-installer below.
        'stevearc/conform.nvim',
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "ConformInfo", "Format" },
        config = function()
            local conform = require("conform")
            conform.setup({
                formatters_by_ft = {},
                default_format_opts = { lsp_format = "fallback", timeout_ms = 3000 },
            })

            -- gl: format the buffer (registered formatter, else LSP).
            vim.keymap.set("n", "gl", function()
                conform.format({ async = true })
            end, { silent = true, desc = "Format buffer (conform → LSP)" })

            -- :Format [range] — whole buffer, or the given range when used as '<,'>:Format
            vim.api.nvim_create_user_command("Format", function(a)
                local opts = { async = true }
                if a.range > 0 then
                    opts.range = {
                        start  = { a.line1, 0 },
                        ["end"] = { a.line2, math.huge },
                    }
                end
                conform.format(opts)
            end, { range = true, desc = "Format buffer/range (conform → LSP)" })
        end
    },

    {
        -- Installs the formatter/linter binaries conform & friends call. Which
        -- formatter a project *uses* is chosen per-project (see conform above);
        -- this just makes the common ones available on the machine.
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        event = "VeryLazy",
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-tool-installer').setup({
                ensure_installed = { 'stylua', 'prettierd', 'shfmt', 'ruff' },
                run_on_start = true,
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
