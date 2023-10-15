local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local fortune = require("alpha.fortune")

-- Inspired by https://github.com/glepnir/dashboard-nvim with my own flair
local header = {
    [[                                                                   ]],
    [[      ████ ██████           █████      ██                    ]],
    [[     ███████████             █████                            ]],
    [[     █████████ ███████████████████ ███   ███████████  ]],
    [[    █████████  ███    █████████████ █████ ██████████████  ]],
    [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
    [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
    [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
}

local function colorize_header()
    local lines = {}

    for _, chars in pairs(header) do
        local line = {
            type = "text",
            val = chars,
            opts = {
                -- hl = "StartLogo" .. i,
                hl = "Identifier",
                shrink_margin = false,
                position = "center",
            },
        }

        table.insert(lines, line)
    end

    return lines
end

dashboard.section.buttons.val = {}

dashboard.section.footer.val = fortune()

local group = vim.api.nvim_create_augroup("CleanDashboard", {})

vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "AlphaReady",
    callback = function()
        vim.opt.showtabline = 0
        vim.opt.showmode = false
        vim.opt.laststatus = 0
        vim.opt.showcmd = false
        vim.opt.ruler = false
    end,
})

vim.api.nvim_create_autocmd("BufUnload", {
    group = group,
    pattern = "<buffer>",
    callback = function()
        vim.opt.showtabline = 2
        vim.opt.showmode = true
        vim.opt.laststatus = 3
        vim.opt.showcmd = true
        vim.opt.ruler = true
    end,
})

alpha.setup({
    layout = {
        { type = "padding", val = 4 },
        { type = "group",   val = colorize_header() },
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        dashboard.section.footer,
    },
    opts = { margin = 5 },
})
