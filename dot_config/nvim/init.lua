---@diagnostic disable: undefined-global
require "options"
require "keymap"
require "filetype"
require "plugins"


-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Restore last position of cursor
vim.cmd[[augroup restore-cursor
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

-- Enter insert mode when entering terminal 
vim.cmd [[
    autocmd TermOpen * startinsert
    " autocmd BufWinEnter,WinEnter term://* startinsert
]]

