local api = vim.api

api.nvim_command [[colorscheme nightfox]]

-- git-gutter
vim.api.nvim_exec('highlight! link SignColumn LineNr', false)

