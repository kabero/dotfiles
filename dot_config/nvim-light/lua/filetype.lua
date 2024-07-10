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

-- yaml
vim.api.nvim_command('autocmd FileType yaml setlocal foldmethod=indent | normal zR')
