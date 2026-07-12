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

-- :X — editable per-project command palette in a centered popup. One
-- shell command per line; <CR> runs the line asynchronously in a terminal
-- split at the bottom. The list is a real file kept under
-- stdpath('data')/x-commands/ (keyed by git root, or cwd when outside a
-- repo), so it persists per project without touching git.
local function x_file()
    local root = vim.fs.root(vim.fn.getcwd(), '.git') or vim.fn.getcwd()
    local dir = vim.fn.stdpath('data') .. '/x-commands'
    vim.fn.mkdir(dir, 'p')
    return dir .. '/' .. root:gsub('/', '%%')
end

-- Runs execute in parallel: each gets its own terminal buffer, and the
-- one output window at the bottom shows the latest run. Earlier runs keep
-- going hidden — <CR> on a still-running line brings its output back to
-- front instead of re-running; finished buffers are swept on the next
-- run. While a command runs, every palette line taking part shows a
-- spinner (extmark virt_text, so it follows the line through edits); on
-- exit they become ✓ or ✗ with the exit code. A visual-line run executes
-- the selected lines as one shell script, top to bottom.
local x_ns = vim.api.nvim_create_namespace('x-palette')
local x_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local x_out_win = nil
local x_terms = {} -- terminal bufnr -> its run; swept once the run is done
local x_runs = {} -- extmark id -> shared run { timer, marks = {id=true}, term, done }

-- Update a mark's text at its *current* (tracked) position, so edits
-- above the line don't snap it back to where the run started.
local function x_update_mark(buf, id, text, hl)
    local pos = vim.api.nvim_buf_get_extmark_by_id(buf, x_ns, id, {})
    if #pos == 0 then return end
    pcall(vim.api.nvim_buf_set_extmark, buf, x_ns, pos[1], pos[2], {
        id = id,
        virt_text = { { text, hl } },
        virt_text_pos = 'eol',
    })
end

local function x_clear_line_marks(buf, lnum)
    local marks = vim.api.nvim_buf_get_extmarks(
        buf, x_ns, { lnum - 1, 0 }, { lnum - 1, -1 }, {})
    for _, m in ipairs(marks) do
        local run = x_runs[m[1]]
        if run then
            run.marks[m[1]] = nil
            if not next(run.marks) and run.timer then
                run.timer:stop()
                run.timer:close()
                run.timer = nil
            end
            x_runs[m[1]] = nil
        end
        vim.api.nvim_buf_del_extmark(buf, x_ns, m[1])
    end
end

-- Put a terminal buffer in the bottom output window (creating the window
-- if needed) without stealing focus.
local function x_show(term)
    if not (x_out_win and vim.api.nvim_win_is_valid(x_out_win)) then
        -- create the split from a normal window: splitting is not
        -- possible while the floating palette is the current window
        local base
        for _, w in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(w).relative == '' then
                base = w
                break
            end
        end
        vim.api.nvim_win_call(base, function()
            vim.cmd('botright 12split')
            x_out_win = vim.api.nvim_get_current_win()
        end)
    end
    vim.api.nvim_win_set_buf(x_out_win, term)
    vim.api.nvim_win_call(x_out_win, function()
        vim.cmd('normal! G') -- cursor on last line so the view follows output
    end)
end

local function x_run(buf, lnums, cmd)
    -- sweep terminals of finished runs; running ones live on hidden
    for term, r in pairs(x_terms) do
        if r.done then
            if vim.api.nvim_buf_is_valid(term) then
                vim.api.nvim_buf_delete(term, { force = true })
            end
            x_terms[term] = nil
        end
    end

    local run = { timer = vim.uv.new_timer(), marks = {}, done = false }
    run.term = vim.api.nvim_create_buf(false, true)
    x_terms[run.term] = run
    x_show(run.term)
    for _, lnum in ipairs(lnums) do
        x_clear_line_marks(buf, lnum)
        local id = vim.api.nvim_buf_set_extmark(buf, x_ns, lnum - 1, 0, {
            virt_text = { { ' ' .. x_frames[1], 'DiagnosticInfo' } },
            virt_text_pos = 'eol',
        })
        run.marks[id] = true
        x_runs[id] = run
    end
    local frame = 1
    run.timer:start(100, 100, vim.schedule_wrap(function()
        if not vim.api.nvim_buf_is_valid(buf) then return end
        frame = frame % #x_frames + 1
        for id in pairs(run.marks) do
            x_update_mark(buf, id, ' ' .. x_frames[frame], 'DiagnosticInfo')
        end
    end))

    -- jobstart(term = true) attaches to the current buffer, so run it
    -- with the output window (showing run.term) as current
    vim.api.nvim_win_call(x_out_win, function()
        run.job = vim.fn.jobstart(cmd, {
            term = true,
            on_exit = function(_, code)
                run.done = true
                if run.timer then
                    run.timer:stop()
                    run.timer:close()
                    run.timer = nil
                end
                vim.schedule(function()
                    if not vim.api.nvim_buf_is_valid(buf) then return end
                    local ok = code == 0
                    local text = ok and ' ✓'
                        or run.killed and ' ✗ killed'
                        or (' ✗ exit ' .. code)
                    local hl = ok and 'DiagnosticOk'
                        or run.killed and 'DiagnosticWarn'
                        or 'DiagnosticError'
                    for id in pairs(run.marks) do
                        x_runs[id] = nil
                        x_update_mark(buf, id, text, hl)
                    end
                end)
            end,
        })
    end)
end

local function x_runnable(line)
    return not (line:match('^%s*$') or line:match('^%s*#'))
end
vim.api.nvim_create_user_command('X', function()
    local file = x_file()
    local buf = vim.fn.bufnr(file)
    if buf ~= -1 then
        local win = vim.fn.bufwinid(buf)
        if win ~= -1 then
            vim.api.nvim_win_close(win, true)
            return
        end
    else
        buf = vim.fn.bufadd(file)
        vim.fn.bufload(buf)
    end
    local width = math.floor(vim.o.columns * 0.7)
    local height = math.floor(vim.o.lines * 0.7)
    vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        border = 'rounded',
        title = ' X ',
        title_pos = 'center',
    })
    vim.bo.filetype = 'sh' -- the file has no extension; highlight as shell
    vim.keymap.set('n', '<CR>', function()
        if vim.bo.modified then
            vim.cmd('silent! write')
        end
        local line = vim.api.nvim_get_current_line()
        if not x_runnable(line) then return end
        local buf = vim.api.nvim_get_current_buf()
        local lnum = vim.fn.line('.')
        -- a still-running line: bring its output to front instead
        local marks = vim.api.nvim_buf_get_extmarks(
            buf, x_ns, { lnum - 1, 0 }, { lnum - 1, -1 }, {})
        for _, m in ipairs(marks) do
            local run = x_runs[m[1]]
            if run and not run.done and vim.api.nvim_buf_is_valid(run.term) then
                x_show(run.term)
                return
            end
        end
        x_run(buf, { lnum }, line)
    end, { buffer = true, desc = 'Run line as shell command (async)' })
    vim.keymap.set('x', '<CR>', function()
        if vim.bo.modified then
            vim.cmd('silent! write')
        end
        local s, e = vim.fn.line('v'), vim.fn.line('.')
        if s > e then s, e = e, s end
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
        local buf = vim.api.nvim_get_current_buf()
        local lnums, cmds = {}, {}
        for lnum = s, e do
            local line = vim.fn.getline(lnum)
            if x_runnable(line) then
                table.insert(lnums, lnum)
                table.insert(cmds, line)
            end
        end
        if #cmds == 0 then return end
        x_run(buf, lnums, table.concat(cmds, '\n'))
    end, { buffer = true, desc = 'Run selected lines as one shell script (async)' })
    vim.keymap.set('n', '<C-c>', function()
        local buf = vim.api.nvim_get_current_buf()
        local lnum = vim.fn.line('.')
        local marks = vim.api.nvim_buf_get_extmarks(
            buf, x_ns, { lnum - 1, 0 }, { lnum - 1, -1 }, {})
        for _, m in ipairs(marks) do
            local run = x_runs[m[1]]
            if run and not run.done and run.job then
                run.killed = true
                vim.fn.jobstop(run.job)
                return
            end
        end
    end, { buffer = true, desc = 'Kill the running command on this line' })
end, { desc = 'Toggle per-project shell-command palette popup' })
vim.keymap.set('n', '<leader>x', '<cmd>X<CR>', { desc = 'Command palette' })

-- Color settings should be at the bottom.
require "colors"
