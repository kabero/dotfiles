---@diagnostic disable: undefined-global
require "options"
require "keymap"
require "filetype"
require "plugins"


-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
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

-- Highlight info
function _G.get_syn_id(transparent)
    local synid = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 1)
    if transparent == 1 then
        return vim.fn.synIDtrans(synid)
    else
        return synid
    end
end
function _G.get_syn_name(synid)
    return vim.fn.synIDattr(synid, 'name')
end
function _G.get_highlight_info()
    local syn_id = get_syn_id(0)
    local trans_id = get_syn_id(1)
    local syn_name = get_syn_name(syn_id)
    local trans_name = get_syn_name(trans_id)
    vim.cmd('highlight ' .. syn_name)
    vim.cmd('highlight ' .. trans_name)
end
vim.api.nvim_create_user_command('HighlightInfo', function()
    get_highlight_info()
end, {})

-- Note command
-- :Note - opens the note with the highest numeric index
-- :Note new - creates a new note with the next available index
-- :Note <name> - opens kabe/notes/<name>.md
vim.api.nvim_create_user_command('Note', function(opts)
    local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    if vim.v.shell_error ~= 0 then
        vim.notify('Not in a git repository', vim.log.levels.ERROR)
        return
    end

    local notes_dir = git_root .. '/kabe/notes'
    local arg = opts.args

    -- Helper: find max numeric index
    local function find_max_index()
        local max_index = -1
        local files = vim.fn.glob(notes_dir .. '/*.md', false, true)
        for _, file in ipairs(files) do
            local basename = vim.fn.fnamemodify(file, ':t:r')
            local num = tonumber(basename)
            if num and num > max_index then
                max_index = num
            end
        end
        return max_index
    end

    if arg == '' then
        -- No argument: open the note with the highest numeric index (or 0 if none)
        local max_index = find_max_index()
        if max_index < 0 then
            max_index = 0
        end
        vim.cmd('edit ' .. notes_dir .. '/' .. max_index .. '.md')
    elseif arg == 'new' then
        -- Create new note with next index
        local max_index = find_max_index()
        local new_index = max_index + 1
        vim.cmd('edit ' .. notes_dir .. '/' .. new_index .. '.md')
    else
        -- Open specific note by name (e.g., "curl" -> curl.md, "5" -> 5.md)
        vim.cmd('edit ' .. notes_dir .. '/' .. arg .. '.md')
    end
end, {
    nargs = '?',
    complete = function(_, _, _)
        local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
        if vim.v.shell_error ~= 0 then
            return { 'new' }
        end
        local notes_dir = git_root .. '/kabe/notes'
        local files = vim.fn.glob(notes_dir .. '/*.md', false, true)
        local completions = { 'new' }
        for _, file in ipairs(files) do
            table.insert(completions, vim.fn.fnamemodify(file, ':t:r'))
        end
        return completions
    end,
})

-- Color settings should be at the bottom.
require "colors"
