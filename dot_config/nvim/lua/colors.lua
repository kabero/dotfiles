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
    augroup END
]]

vim.cmd([[colorscheme everforest]])
