return {
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        dependencies = { "nvim-mini/mini.icons" },
        -- No lazy-loading (upstream recommendation): oil must hijack directory
        -- buffers, so `nvim <dir>` shows nothing if it loads on cmd/keys only.
        lazy = false,
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent dir (Oil)" },
        },
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
            -- copilot.vim matches by exact &filetype, so only real filetype
            -- names work here (the old extension/glob keys like "md", ".*",
            -- "pem", "tf" never matched). Secret/credential FILES are blocked
            -- by path in the BufEnter autocmd below, not here.
            vim.g.copilot_filetypes = {
                ["*"] = true,
                ["help"] = false,
                ["gitcommit"] = false,
                ["gitrebase"] = false,
                ["hgcommit"] = false,
                ["svn"] = false,
                ["cvs"] = false,
                ["markdown"] = false,
                ["terraform"] = false,
                ["sshconfig"] = false,
                ["dosini"] = false,
                ["sql"] = false,
                ["conf"] = false,
                ["config"] = false,
                ["passwd"] = false,
                ["shadow"] = false,
                ["sudoers"] = false,
            }
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
        "kabero/sensei.nvim",
        cmd = { "Sensei", "SenseiInstall", "SenseiPrompt", "SenseiStatus", "SenseiClearHints" },
        config = function()
            -- Patch the plugin's own defaults rather than passing opts here.
            -- A project's exrc calls require("sensei").setup{...} with only its
            -- own keys, and setup() rebuilds the config from these defaults
            -- every time — so whatever is set here survives that second call.
            local defaults = require("sensei.config").defaults
            defaults.prompt.language = "Japanese"
            -- The build driver is per-project (cargo / go / make / npm ...).
            -- Left on, run_build would offer `cargo` inside a Go repo, so the
            -- project opts in from .nvim.lua instead.
            defaults.tools.build.enabled = false
            require("sensei").setup({})
        end,
        -- Loading: the sidecar (`claude` in a :terminal) talks to *this* Neovim
        -- and fails with "sensei.nvim is not loaded" unless the plugin is
        -- already in. The require() in a project's .nvim.lua is what pulls it
        -- in at startup — same pattern as conform's per-project formatters:
        --     require("sensei").setup({
        --         prompt = { subject = "writing a TCP/IP stack in Rust" },
        --         tools = { build = { enabled = true, cmd = "cargo" } },
        --     })
        -- Then :SenseiInstall once per project, and `:terminal claude`.
    },
}
