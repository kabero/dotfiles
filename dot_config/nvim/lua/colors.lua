-- To use vim's colors, comment out the folloing lines.
local function setup_highlights()
    local highlights = {
        -- { 'EndOfBuffer', { bg = 'none' } },
        -- { 'Folded', { bg = 'none' } },
        -- { 'LineNr', { bg = 'none', fg = '#707070' } },
        -- { 'CursorLineNr', { bg = 'none', fg = '#b14a4a' } },
        -- { 'NonText', { bg = 'none' } },
        -- { 'Normal', { bg = 'none' } },
        -- { 'NormalNC', { bg = 'none' } },
        -- { 'CopilotSuggestion', { fg = '#bb00cc' } },
        -- { 'SignColumn', { bg = 'NONE' } },
        -- { 'CursorLine', { bg = '#2f2f2f' } },
        -- -- Comment
        -- { 'Comment', { bg = 'none', fg = '#6f6f6f' } },
        -- -- Search
        -- { 'Search', { bg = '#7a6d94', fg = '#000000' } },
        -- { 'IncSearch', { bg = '#5d20d6', fg = '#FFFFFF' } },
        -- -- Tabline
        -- { 'TabLineSel', { bg = 'NONE', fg = '#b14a4a' } },
        -- { 'TabLine', { bg = 'NONE', fg = '#aaaaaa' } },
        -- { 'TabLineFill', { bg = 'NONE', fg = '#d0d0d0' } },
        -- -- Telescope
        -- { 'TelescopeMatching', { bg = 'none', fg = '#5f9ea0' } },
        -- -- Winbar
        -- { 'WinBar', { bg = 'NONE', fg = '#d3c6aa' } },
        -- { 'WinBarNC', { bg = 'NONE', fg = '#888888' } },
    }

    for _, hl in ipairs(highlights) do
        vim.api.nvim_set_hl(0, hl[1], hl[2])
    end

    vim.cmd([[highlight clear TelescopeSelection]])
    vim.cmd([[highlight link TelescopeSelection CursorLine]])
    vim.opt.cursorline = true
end

vim.api.nvim_create_augroup('myHighlighting', { clear = true })
vim.api.nvim_create_autocmd('Colorscheme', {
    group = 'myHighlighting',
    callback = setup_highlights,
})

-- vim.cmd([[colorscheme everforest]])
vim.cmd([[colorscheme kanagawa]])
-- vim.cmd([[colorscheme catppuccin]])
