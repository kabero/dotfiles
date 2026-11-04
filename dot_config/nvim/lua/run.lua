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
