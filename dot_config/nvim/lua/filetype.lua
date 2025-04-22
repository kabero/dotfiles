-- chezmoi
vim.filetype.add({
    pattern = {
        ['${HOME}/.local/share/chezmoi/.*'] = {
            function(
                path,
                buf
            )
                if path:match('/dot_') then
                    return vim.filetype.match({
                        filename = path:gsub('/dot_', '/.'),
                        buf = buf,
                    })
                end
            end,
            { priority = -math.huge }
        },
    },
})

-- .envrc
vim.api.nvim_command('autocmd BufRead,BufNewFile .envrc setlocal filetype=sh')

-- .env
vim.api.nvim_command('autocmd BufRead,BufNewFile .env.* setlocal filetype=sh')

-- yaml
vim.api.nvim_command('autocmd FileType yaml setlocal foldmethod=indent | normal zR')

-- tmpl
vim.filetype.add({
    extension = {
        tmpl = function(path, bufnr)
            local original_ext = path:match("%.([^.]+)%.tmpl$")
            if original_ext then
                return vim.filetype.match({ filename = path:gsub("%.tmpl$", "") })
            end
            return "text"
        end,
    },
})
