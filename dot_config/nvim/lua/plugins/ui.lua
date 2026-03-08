local lualine_colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
    white    = '#AAAAAA',
}

local lualine_conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

return {
    {
        "nvim-tree/nvim-web-devicons",
    },

    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local lualine = require('lualine')
            local colors = lualine_colors
            local conditions = lualine_conditions

            local config = {
                options = {
                    component_separators = '',
                    section_separators = '',
                    globalstatus = true,
                    theme = {
                        normal = { c = { fg = colors.fg, bg = colors.bg } },
                        inactive = { c = { fg = colors.fg, bg = colors.bg } },
                    },
                },
                sections = {
                    lualine_a = {}, lualine_b = {},
                    lualine_y = {}, lualine_z = {},
                    lualine_c = {}, lualine_x = {},
                },
                inactive_sections = {
                    lualine_a = {}, lualine_b = {},
                    lualine_y = {}, lualine_z = {},
                    lualine_c = {}, lualine_x = {},
                },
            }

            local function ins_left(component)
                table.insert(config.sections.lualine_c, component)
            end
            local function ins_right(component)
                table.insert(config.sections.lualine_x, component)
            end

            ins_left {
                'filename',
                filestatus = true,
                path = 1,
                cond = conditions.buffer_not_empty,
                color = { fg = colors.white, gui = 'bold' },
            }

            ins_right {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                symbols = { error = 'E ', warn = 'W ', info = 'I ' },
                diagnostics_color = {
                    color_error = { fg = colors.red },
                    color_warn = { fg = colors.yellow },
                    color_info = { fg = colors.cyan },
                },
            }

            ins_right {
                function()
                    local msg = 'No Active Lsp'
                    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                    local clients = vim.lsp.get_clients()
                    if next(clients) == nil then
                        return msg
                    end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and client.name ~= "null-ls" then
                            return client.name
                        end
                    end
                    return msg
                end,
                icon = 'LSP:',
                color = { fg = colors.white, gui = 'bold' },
            }

            ins_right {
                'branch',
                color = { fg = colors.white, gui = 'bold' },
            }

            ins_right {
                'diff',
                symbols = { added = '+', modified = '~', removed = '-' },
                diff_color = {
                    added = { fg = colors.green },
                    modified = { fg = colors.orange },
                    removed = { fg = colors.red },
                },
                cond = conditions.hide_in_width,
            }

            lualine.setup(config)
        end
    },

    {
        'b0o/incline.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local devicons = require 'nvim-web-devicons'
            require('incline').setup {
                render = function(props)
                    local cursor_line = vim.api.nvim_win_get_cursor(props.win)[1]
                    local win_first_line = vim.fn.line('w0', props.win)
                    if cursor_line - win_first_line < 5 then
                        return nil
                    end

                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':.')
                    if filename == '' then
                        filename = '[No Name]'
                    end
                    local ft_icon, ft_color = devicons.get_icon_color(filename)

                    local function get_git_diff()
                        local icons = { removed = '-', changed = '~', added = '+' }
                        local signs = vim.b[props.buf].gitsigns_status_dict
                        local labels = {}
                        if signs == nil then
                            return labels
                        end
                        for name, icon in pairs(icons) do
                            if tonumber(signs[name]) and signs[name] > 0 then
                                table.insert(labels, { icon .. signs[name] .. ' ', group = 'Diff' .. name })
                            end
                        end
                        if #labels > 0 then
                            table.insert(labels, { '┊ ' })
                        end
                        return labels
                    end

                    local function get_diagnostic_label()
                        local icons = { error = '', warn = '', info = '', hint = '' }
                        local label = {}
                        for severity, icon in pairs(icons) do
                            local n = #vim.diagnostic.get(props.buf,
                                { severity = vim.diagnostic.severity[string.upper(severity)] })
                            if n > 0 then
                                table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
                            end
                        end
                        if #label > 0 then
                            table.insert(label, { '┊ ' })
                        end
                        return label
                    end

                    return {
                        { get_diagnostic_label() },
                        { get_git_diff() },
                        { (ft_icon or '') .. ' ', guifg = ft_color,                                            guibg = 'none' },
                        { filename .. ' ',        gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold' },
                    }
                end,
            }
        end,
    },

    {
        "hiphish/rainbow-delimiters.nvim",
        event = "VeryLazy",
        config = function()
            local rainbow_delimiters = require 'rainbow-delimiters'
            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow_delimiters.strategy['global'],
                    vim = rainbow_delimiters.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                highlight = {
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                    'RainbowDelimiterRed',
                },
            }

            vim.keymap.set('n', '<leader>7', '<cmd>lua require"rainbow-delimiters".toggle(0)<CR>',
                { noremap = true, silent = true })
        end
    },

    {
        'RRethy/vim-illuminate',
        event = "BufReadPost",
        config = function()
            require('illuminate').configure({
                filetypes_denylist = {
                    'dirbuf',
                    'dirvish',
                    'fugitive',
                    'markdown',
                    'sagafinder',
                },
                under_cursor = false,
            })
        end
    },

    {
        "norcalli/nvim-colorizer.lua",
        ft = { "css", "scss", "html", "javascript", "typescript", "blade" },
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 800
            local wk = require("which-key")
            wk.setup({})
            vim.api.nvim_set_keymap("n", "<leader>w", ":WhichKey<CR>", { noremap = true, silent = true })

            wk.add({
                { "<leader>f", group = "find" },
                { "<leader>fh", desc = "oldfiles" },
                { "<leader>fj", desc = "find_files" },
                { "<leader>fk", desc = "live_grep" },
                { "<leader>fl", desc = "grep_string" },
                { "<leader>fi", desc = "incoming calls" },
                { "<leader>fo", desc = "outgoing calls" },
                { "<leader>fn", desc = "file browser" },
                { "<leader>s", desc = "easymotion" },
                { "<leader>w", desc = "which-key" },
                { "ga", desc = "[LSP] code action" },
                { "gd", desc = "[LSP] go to definition" },
                { "gp", desc = "[LSP] peek definition" },
                { "gD", desc = "[LSP] peek declaration" },
                { "gi", desc = "[LSP] go to implementation" },
                { "gr", desc = "[LSP] references" },
            })
        end
    },
}
