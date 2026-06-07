return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'master',
        build = ':TSUpdate',
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            'windwp/nvim-ts-autotag',
            -- Pin to master to match nvim-treesitter's classic (master) API;
            -- the default `main` branch is the incompatible rewrite.
            { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'master' },
        },
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    'bash', 'c', 'cpp', 'css', 'dart', 'dockerfile',
                    'gitcommit', 'gitignore', 'go', 'graphql', 'html',
                    'javascript', 'jq', 'json', 'json5', 'lua',
                    'markdown', 'markdown_inline', 'php', 'python',
                    'regex', 'ruby', 'rust', 'scala', 'scss', 'sql',
                    'terraform', 'tsx', 'typescript', 'vim', 'vue', 'yaml', 'zig',
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                    disable = function(lang, buf)
                        if vim.tbl_contains({ 'markdown' }, lang) then
                            return false
                        end
                        local max_filesize = 1000 * 1024
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                },
                autotag = { enable = true },
                indent = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- jump forward to the textobject like targets.vim
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- record positions in the jumplist
                        goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
                        goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
                    },
                },
            }
        end
    },

    {
        'EmranMR/tree-sitter-blade',
        ft = "blade",
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function()
            local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
            parser_config.blade = {
                install_info = {
                    url = "https://github.com/EmranMR/tree-sitter-blade",
                    files = { "src/parser.c" },
                    branch = "main",
                },
                filetype = "blade"
            }
            vim.cmd [[
                augroup BladeFiltypeRelated
                    au BufNewFile,BufRead *.blade.php set ft=blade
                augroup END
            ]]
        end
    },
}
