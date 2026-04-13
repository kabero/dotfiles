return {
    {
        'is0n/jaq-nvim',
        event = 'VeryLazy',
        config = function()
            require('jaq-nvim').setup {
                cmds = {
                    internal = {
                        lua = 'luafile %',
                        vim = 'source %',
                        markdown = 'PreviewMarkdown'
                    },
                    external = {
                        c          = 'gcc %; ./a.out; rm a.out',
                        cpp        = 'g++ %; ./a.out; rm a.out',
                        go         = 'go run %',
                        python     = 'python %',
                        ruby       = '[ -d .bundle ] && bundle exec ruby % || ruby %',
                        rust       = 'rustc % -o tmp.out; ./tmp.out; rm tmp.out',
                        sh         = 'sh %',
                        zig        = 'zig build run',
                        javascript = 'node %',
                        typescript = './node_modules/.bin/ts-node %'
                    }
                },
                behavior = {
                    default = 'bang',
                    startinsert = false,
                    wincmd = false,
                    autosave = true,
                },
                ui = {
                    float = {
                        border = 'single'
                    },
                    quickfix = {
                        postion = 'bot',
                        size = 10,
                    }
                }
            }
            vim.keymap.set('n', '<leader>q', '<cmd>Jaq<CR>')
        end
    },

    {
        "tyru/open-browser.vim",
        event = 'VeryLazy',
        config = function()
            vim.keymap.set('n', 'go', '<Plug>(openbrowser-smart-search)', { noremap = false, silent = true })
            vim.keymap.set('v', 'go', '<Plug>(openbrowser-smart-search)', { noremap = false, silent = true })
        end
    },

    {
        'vim-denops/denops.vim',
        event = "VeryLazy",
    },

    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        lazy = false,
    },

    {
        "github/copilot.vim",
        event = "InsertEnter",
        config = function()
            vim.keymap.set("i", "<C-l>", 'copilot#Accept()', { silent = true, expr = true, replace_keycodes = false })
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_next_edit_suggestions = false
            vim.keymap.set('i', '<C-c>', function()
                vim.fn['copilot#Dismiss']()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 'n', true)
            end, { noremap = true, silent = true })
            vim.g.copilot_filetypes = {
                ["*"] = true,
                ["help"] = false,
                ["gitcommit"] = false,
                ["gitrebase"] = false,
                ["hgcommit"] = false,
                ["svn"] = false,
                ["cvs"] = false,
                ["md"] = false,
                [".*"] = false,
                [".env"] = false,
                [".env.production"] = false,
                [".env.prod"] = false,
                ["env"] = false,
                ["ssh_config"] = false,
                ["passwd"] = false,
                ["shadow"] = false,
                ["sudoers"] = false,
                ["pem"] = false,
                ["key"] = false,
                ["cert"] = false,
                ["crt"] = false,
                ["ca"] = false,
                ["p12"] = false,
                ["pfx"] = false,
                ["jks"] = false,
                ["gpg"] = false,
                ["asc"] = false,
                ["ini"] = false,
                ["cfg"] = false,
                ["conf"] = false,
                ["config"] = false,
                ["sql"] = false,
                ["sqlite"] = false,
                ["sqlite3"] = false,
                ["db"] = false,
                ["tf"] = false,
                ["tfvars"] = false,
                ["tfstate"] = false,
                ["kubeconfig"] = false,
                ["bin"] = false,
                ["exe"] = false,
                ["dll"] = false,
                ["so"] = false,
                ["dylib"] = false,
            }
            vim.g.copilot_enabled = true
            vim.g.copilot_show_ghost_text = true

            vim.api.nvim_create_autocmd({"BufEnter", "BufNewFile"}, {
                pattern = "*",
                callback = function()
                    local bufname = vim.fn.expand("%:p")
                    local disable_patterns = {
                        "%.env",
                        "%.env%.",
                        "/%.ssh/",
                        "/%.gnupg/",
                        "/%.aws/",
                        "/%.kube/",
                        "/%.docker/",
                        "%.pem$",
                        "%.key$",
                        "%.crt$",
                        "%.p12$",
                        "/private/",
                        "/secrets/",
                        "/credentials/",
                        "id_rsa",
                        "id_dsa",
                        "id_ecdsa",
                        "id_ed25519",
                        "%.asc$",
                        "%.gpg$",
                        "/vault/",
                        "%.tfstate",
                        "%.tfvars",
                        "shadow$",
                        "passwd$",
                        "%.sqlite",
                        "%.db$",
                    }

                    for _, pattern in ipairs(disable_patterns) do
                        if bufname:match(pattern) then
                            vim.b.copilot_enabled = false
                            break
                        end
                    end
                end
            })
        end
    },

    {
        'cordx56/rustowl',
        version = '*',
        build = 'cargo install --path . --locked',
        ft = "rust",
        opts = {
            client = {
                on_attach = function(_, buffer)
                    vim.keymap.set('n', '<leader>o', function()
                        require('rustowl').toggle(buffer)
                    end, { buffer = buffer, desc = 'Toggle RustOwl' })
                end
            },
        },
    },

    {
        'folke/sidekick.nvim',
        version = '*',
        event = 'VeryLazy',
        opts = {
            cli = {
                mux = {
                    enabled = true,
                    backend = "tmux",
                },
                win = {
                    keys = {}
                }
            },
            nes = {
                enabled = true,
            },
        },
        keys = {
            {
                "<tab>",
                function()
                    if require("sidekick").nes_jump_or_apply() then
                        return
                    end
                    if vim.lsp.inline_completion and vim.lsp.inline_completion.get and vim.lsp.inline_completion.get() then
                        return
                    end
                    return "<tab>"
                end,
                mode = { "i", "n" },
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<leader>ac",
                function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
                desc = "Sidekick Toggle Claude",
            },
            {
                "<leader>at",
                function() require("sidekick.cli").send({ msg = "{this}" }) end,
                mode = { "x", "n" },
                desc = "Send This",
            },
            {
                "<leader>af",
                function() require("sidekick.cli").send({ msg = "{file}" }) end,
                desc = "Send File",
            },
            {
                "<leader>av",
                function() require("sidekick.cli").send({ msg = "{selection}" }) end,
                mode = { "x" },
                desc = "Send Visual Selection",
            },
        },
    },
}
