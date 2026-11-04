-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.hl.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Restore last position of cursor
local restore_cursor_group = vim.api.nvim_create_augroup('restore-cursor', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
    group = restore_cursor_group,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    group = restore_cursor_group,
    callback = function()
        -- Only center if buffer is not special and cursor is below half window
        if vim.bo.buftype == '' and vim.fn.line('.') > vim.fn.winheight(0) / 2 then
            vim.cmd('normal! zz')
        end
    end,
})

-- Avoid automatically commenting when adding a new line
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        vim.opt_local.formatoptions:remove({ 'r', 'o' })
    end,
})

-- Highlight ideographic space
local ideographic_space_group = vim.api.nvim_create_augroup('highlightIdegraphicSpace', { clear = true })

vim.api.nvim_create_autocmd('Colorscheme', {
    group = ideographic_space_group,
    callback = function()
        vim.api.nvim_set_hl(0, 'IdeographicSpace', { bg = 'DarkGreen' })
    end,
})

vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter' }, {
    group = ideographic_space_group,
    callback = function()
        vim.fn.matchadd('IdeographicSpace', '　')
    end,
})

-- Highlight chezmoi template files
local tmpl_group = vim.api.nvim_create_augroup('highlightTmplFile', { clear = true })

vim.api.nvim_create_autocmd('BufRead', {
    group = tmpl_group,
    pattern = '*.tmpl',
    callback = function()
        local fname_without_tmpl = vim.fn.expand('%:t:r')
        if fname_without_tmpl == "dot_zshrc" then
            vim.bo.filetype = "zsh"
        else
            vim.bo.filetype = vim.fn.expand('%:t:r:e')
        end
    end,
})

-- Terminal
vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
    end,
})
