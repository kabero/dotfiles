require('nvim-treesitter.configs').setup {
    ensure_installed = {
        'bash',
        'c',
        'cpp',
        'css',
        'dart',
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
        'terraform',
        'tsx',
        'typescript',
        'vim',
        'vue',
        'yaml',
        'zig',
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },
    autotag = { enable = true, },
    indent = { enable = true }
}
