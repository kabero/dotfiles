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


-- Per-window markdown tweaks, re-evaluated on enter so they follow the
-- buffer's filetype even when a window is reused for another file. Limited to
-- normal buffers so plugin/terminal windows are left alone.
--   * No cursorline (it clashes with render-markdown's rendered current line /
--     heading bars).
--   * Highlight circled numbers (①②③ …) — they render cramped at single-cell
--     width, so a bright bold match (priority above treesitter) keeps them
--     readable. matchadd is window-local, hence the per-window refresh.
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
    group = filetype_group,
    callback = function()
        if vim.bo.buftype ~= '' then return end
        local is_markdown = vim.bo.filetype == 'markdown'

        vim.wo.cursorline = not is_markdown

        for _, m in ipairs(vim.fn.getmatches()) do
            if m.group == 'CircledNumber' then
                vim.fn.matchdelete(m.id)
            end
        end
        if is_markdown then
            vim.fn.matchadd('CircledNumber', "[⓪①-⑳⓫-⓴㉑-㉟㊱-㊿❶-❿⓿]", 120)
        end
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
