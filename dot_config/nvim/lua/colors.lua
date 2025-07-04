-- To use vim's colors, comment out the folloing lines.
vim.cmd [[
    augroup myHighlighting
        autocmd!
        autocmd Colorscheme * highlight EndOfBuffer ctermbg=none guibg=none
        autocmd Colorscheme * highlight Folded ctermbg=none guibg=none
        autocmd Colorscheme * highlight LineNr ctermbg=none guibg=none guifg=#707070
        autocmd Colorscheme * highlight CursorLineNr ctermbg=none guibg=none guifg=#b14a4a
        autocmd Colorscheme * highlight NonText ctermbg=none guibg=none
        autocmd Colorscheme * highlight Normal ctermbg=none guibg=none
        autocmd Colorscheme * highlight NormalNC ctermbg=none guibg=none
        autocmd Colorscheme * set cursorline
        autocmd Colorscheme * highlight CopilotSuggestion guifg=#bb00cc ctermfg=blue
        autocmd Colorscheme * highlight SignColumn guibg=NONE
        autocmd Colorscheme * highlight CursorLine ctermbg=none guibg=#2f2f2f

        " Comment
        autocmd Colorscheme * highlight Comment ctermbg=none guibg=none guifg=#6f6f6f

        " Search
        autocmd Colorscheme * highlight Search guibg=#7a6d94 guifg=#000000
        autocmd Colorscheme * highlight IncSearch guibg=#5d20d6 guifg=#FFFFFF
        
        " Tabline
        autocmd Colorscheme * highlight TabLineSel guibg=NONE guifg=#b14a4a
        autocmd Colorscheme * highlight TabLine guibg=NONE guifg=#aaaaaa
        autocmd Colorscheme * highlight TabLineFill guibg=NONE guifg=#d0d0d0

        " Telescope
        autocmd Colorscheme * highlight TelescopeMatching guibg=none guifg=#5f9ea0
        autocmd Colorscheme * highlight clear TelescopeSelection
        autocmd Colorscheme * highlight link TelescopeSelection CursorLine
        
        " Winbar
        autocmd Colorscheme * highlight WinBar guibg=NONE guifg=#d3c6aa
        autocmd Colorscheme * highlight WinBarNC guibg=NONE guifg=#888888
    augroup END
]]

vim.cmd([[colorscheme everforest]])
