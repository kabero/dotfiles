---@diagnostic disable: undefined-global
require "options"
require "keymap"
require "filetype"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
    { import = "plugins" },
})


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

-- :Run / <leader>q — run the current file by filetype (replaces jaq-nvim).
-- In the shell commands `%` is expanded by vim to the current file name,
-- so `[ -d .bundle ] && bundle exec ruby % || ruby %` works as-is.
local run_internal = {
    lua      = 'luafile %',
    vim      = 'source %',
    markdown = 'RenderMarkdown toggle',
}
local run_shell = {
    c          = 'gcc %; ./a.out; rm a.out',
    cpp        = 'g++ %; ./a.out; rm a.out',
    go         = 'go run %',
    python     = 'python %',
    ruby       = '[ -d .bundle ] && bundle exec ruby % || ruby %',
    rust       = 'rustc % -o tmp.out; ./tmp.out; rm tmp.out',
    sh         = 'sh %',
    zig        = 'zig build run',
    javascript = 'node %',
    typescript = './node_modules/.bin/ts-node %',
}
-- Project tasks: a repo's .nvim.lua (exrc runs after init.lua) fills this
-- with name → shell string (`%` expands as above) or lua function, same
-- pattern as conform's per-project formatters:
--     local t = RunTasks
--     t.test    = 'bundle exec rspec %'
--     t.default = 'bin/rails s'      -- what bare :Run / <leader>q runs
RunTasks = {}

vim.api.nvim_create_user_command('Run', function(a)
    local task
    if a.args ~= '' then
        task = RunTasks[a.args]
        if not task then
            vim.notify('Run: no task "' .. a.args .. '" (define it in .nvim.lua)', vim.log.levels.WARN)
            return
        end
    else
        local ft = vim.bo.filetype
        local internal = run_internal[ft]
        task = RunTasks.default
            or (internal and function() vim.cmd(internal) end)
            or run_shell[ft]
        if not task then
            vim.notify('Run: no command for filetype "' .. ft .. '"', vim.log.levels.WARN)
            return
        end
    end
    if vim.bo.modified then
        vim.cmd('silent! write')
    end
    if type(task) == 'function' then
        task()
    else
        vim.cmd('!' .. task)
    end
end, {
    nargs = '?',
    complete = function()
        local names = vim.tbl_keys(RunTasks)
        table.sort(names)
        return names
    end,
    desc = 'Run current file by filetype, or a project task from .nvim.lua',
})
vim.keymap.set('n', '<leader>q', '<cmd>Run<CR>', { desc = 'Run file' })

-- Color settings should be at the bottom.
require "colors"
