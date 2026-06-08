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

    -- render-markdown.nvim legibility tuning.
    -- It registers its groups with default=true, so these explicit definitions
    -- win. Keep the banded heading layout but swap the muddy diff-derived bars
    -- for consistent, per-level dragon accents blended onto Normal; lift code
    -- block / inline backgrounds clear of Normal so they don't get lost.
    local function channels(c)
        return math.floor(c / 65536) % 256, math.floor(c / 256) % 256, c % 256
    end
    local function blend(fg, bg, a)
        local fr, fg2, fb = channels(fg)
        local br, bg2, bb = channels(bg)
        return string.format('#%02x%02x%02x',
            math.floor(fr * a + br * (1 - a) + 0.5),
            math.floor(fg2 * a + bg2 * (1 - a) + 0.5),
            math.floor(fb * a + bb * (1 - a) + 0.5))
    end

    local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
    if normal_bg then
        -- one dragon accent hue per heading level (H1..H6).
        -- bar_strength = how much accent is mixed into the bar (higher = more
        -- vivid / less washed-out); nudge this single number to taste.
        local accents = { 0xc4746e, 0xc4b28a, 0x87a987, 0x8ea4a2, 0x8ba4b0, 0xa292a3 }
        local bar_strength = 0.45
        local normal_fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg or 0xc5c9c5
        -- The bars carry the per-level hue, so the heading *text* just needs to
        -- stay legible on them: a bright, near-white bold fg. render-markdown
        -- only paints the line background (H{i}Bg, bg-only) and leaves the text
        -- to treesitter @markup.heading.N, so both are set here.
        local head_fg = blend(0xffffff, normal_fg, 0.55)
        for i, accent in ipairs(accents) do
            vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. i .. 'Bg', { bg = blend(accent, normal_bg, bar_strength) })
            vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. i, { fg = head_fg, bold = true })             -- # icon / sign
            vim.api.nvim_set_hl(0, '@markup.heading.' .. i .. '.markdown', { fg = head_fg, bold = true }) -- heading text
        end
        -- Code block: sink the "well" a notch darker than Normal so it reads as
        -- a recessed panel, and recolor the plain (no-language) block body off
        -- the loud green @markup.raw to neutral Normal fg (language-injected
        -- blocks keep their syntax colors on top).
        local code_bg = blend(0x000000, normal_bg, 0.40) -- darker than Normal
        vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = code_bg })
        vim.api.nvim_set_hl(0, '@markup.raw.block.markdown', { fg = normal_fg })
        -- Inline code: no background box (it was too loud mid-sentence), just a
        -- calm dragonRed foreground so it still reads as code.
        vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { fg = '#c4746e' })

        -- Circled numbers (①②③ …) render cramped at single-cell width; a bright
        -- bold color keeps them readable. Applied as a window match in markdown
        -- buffers (see filetype.lua).
        vim.api.nvim_set_hl(0, 'CircledNumber', { fg = '#e6c384', bold = true })
    end
end

vim.api.nvim_create_augroup('myHighlighting', { clear = true })
vim.api.nvim_create_autocmd('Colorscheme', {
    group = 'myHighlighting',
    callback = setup_highlights,
})

-- vim.cmd([[colorscheme everforest]])
vim.cmd([[colorscheme kanagawa]])
-- vim.cmd([[colorscheme catppuccin]])
