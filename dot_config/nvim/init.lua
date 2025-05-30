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
vim.cmd [[
augroup restore-cursor
  autocmd!
  autocmd BufReadPost *
        \ : if line("'\"") >= 1 && line("'\"") <= line("$")
        \ |   exe "normal! g`\""
        \ | endif
  autocmd BufWinEnter *
        \ : if empty(&buftype) && line('.') > winheight(0) / 2
        \ |   execute 'normal! zz'
        \ | endif
augroup END
]]

-- Avoid automatically commenting when adding a new line
vim.cmd [[ autocmd FileType * setlocal formatoptions-=r ]]
vim.cmd [[ autocmd FileType * setlocal formatoptions-=o ]]

-- Highlight ideographic space
vim.cmd [[
    augroup highlightIdegraphicSpace
        autocmd!
        autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
        autocmd VimEnter,WinEnter * match IdeographicSpace /　/
    augroup END
]]

-- Highlight chezmoi template files
vim.cmd [[
    augroup highlightTmplFile
        autocmd!
        autocmd BufRead *.tmpl call g:DetermineExtOfTmpl()
        function! g:DetermineExtOfTmpl()
            let fname_without_tmpl = expand('%:t:r')
            if fname_without_tmpl == "dot_zshrc"
                let &filetype="zsh"
            else
                let &filetype=expand('%:t:r:e')
            endif
        endfunction
    augroup END
]]

-- Terminal
vim.cmd [[
    autocmd TermOpen * setlocal norelativenumber
    autocmd TermOpen * setlocal nonumber
]]

-- Disable line numbers in Notes directory
vim.cmd [[
    autocmd BufEnter ~/Notes/** setlocal norelativenumber
    autocmd BufEnter ~/Notes/** setlocal nonumber
]]

-- Config of neovide
if vim.g.neovide then
    vim.cmd([[autocmd VimEnter * cd ~/Notes/]])
    vim.cmd([[autocmd VimEnter * edit ~/Notes/note.md]])
    vim.o.guifont = "RobotoMono Nerd Font Mono"
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_refresh_rate_idle = 5
    vim.g.neovide_scroll_animation_length = 0.3
    vim.env.LANG      = 'ja_JP.UTF-8'
    vim.env.LC_CTYPE  = 'ja_JP.UTF-8'
end

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

-- Color settings should be at the bottom.
require "colors"
