-- To use vim's colors, comment out the folloing lines.
vim.cmd [[
    augroup myHighlighting
        autocmd!
        autocmd Colorscheme * highlight EndOfBuffer ctermbg=none guibg=none
        autocmd Colorscheme * highlight Folded ctermbg=none guibg=none
        autocmd Colorscheme * highlight LineNr ctermbg=none guibg=none
        autocmd Colorscheme * highlight NonText ctermbg=none guibg=none
        autocmd Colorscheme * highlight Normal ctermbg=none guibg=none
        autocmd Colorscheme * highlight NormalNC ctermbg=none guibg=none
        autocmd Colorscheme * highlight TabLineFill ctermbg=none guibg=none
        autocmd Colorscheme * set cursorline
        autocmd Colorscheme * highlight CursorLine ctermbg=none guibg=#2a2a2a
        autocmd Colorscheme * highlight CopilotSuggestion guifg=#bb00cc ctermfg=blue
        autocmd Colorscheme * highlight SignColumn guibg=NONE
    augroup END
]]

vim.cmd([[colorscheme everforest]])
