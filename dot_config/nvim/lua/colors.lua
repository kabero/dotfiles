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
        autocmd Colorscheme * highlight CursorLine ctermbg=none guibg=#212121
        autocmd Colorscheme * highlight CopilotSuggestion guifg=#bb00cc ctermfg=blue
        autocmd Colorscheme * highlight SignColumn guibg=NONE
        autocmd Colorscheme * highlight Search guibg=#7a6d94 guifg=#000000
        autocmd Colorscheme * highlight IncSearch guibg=#5d20d6 guifg=#FFFFFF

        autocmd Colorscheme * highlight TabLineSel guibg=NONE guifg=#aaaaaa
        autocmd Colorscheme * highlight TabLine guibg=#3a3a3a guifg=#d0d0d0
        autocmd Colorscheme * highlight TabLineFill guibg=#1c1c1c guifg=#d0d0d0
    augroup END
]]

vim.cmd([[colorscheme everforest]])
