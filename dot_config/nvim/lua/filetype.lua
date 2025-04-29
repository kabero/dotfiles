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

-- Create a group for file type related autocommands
local filetype_group = vim.api.nvim_create_augroup('MyFileTypeSettings', { clear = true })

-- env files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '.envrc', '.env.*' },
    group = filetype_group,
    callback = function()
        vim.opt_local.filetype = 'sh'
    end,
})

-- yaml files
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'yaml',
    group = filetype_group,
    callback = function()
        vim.opt_local.foldmethod = 'indent'
        vim.cmd('normal zR')
    end,
})

-- tmpl
vim.filetype.add({
    extension = {
        tmpl = function(path, _)
            local original_ext = path:match("%.([^.]+)%.tmpl$")
            if original_ext then
                return vim.filetype.match({ filename = path:gsub("%.tmpl$", "") })
            end
            return "text"
        end,
    },
})

-- c
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'c',
    group = filetype_group,
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})


-- Disable search highlighting color for specific file types
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sagafinder', 'TelescopePrompt' },
    group = filetype_group,
    callback = function()
        vim.cmd('highlight Search ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE')
    end,
})
