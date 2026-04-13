return {
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
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
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    { name = "nvim_lsp_signature_help" },
                }, {
                    { name = "buffer", keyword_length = 2 }
                }),
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-f>"] = cmp.mapping.confirm { select = true },
                    ["<TAB>"] = cmp.mapping.confirm { select = true },
                    ["<CR>"]  = cmp.mapping.confirm { select = false },
                }),
                experimental = {
                    ghost_text = false,
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
                performance = {
                    max_view_entries = 30
                }
            })
        end
    },
}
