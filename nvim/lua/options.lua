local opt = vim.opt

-- General
opt.mouse = 'a'
opt.fileformats = 'unix', 'mac', 'dos'
opt.clipboard:append { 'unnamedplus' }
vim.cmd("language C")
-- vim.cmd [[let g:python_host_prog = '/usr/bin/python2']]
vim.cmd [[let g:python3_host_prog = expand('~/.pyenv/versions/nvim3/bin/python')]]

vim.cmd [["set encoding=utf-8"]]

-- Search
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true
opt.wrapscan = true
opt.hlsearch = true

-- View
opt.number = true
opt.ruler = true
opt.numberwidth = 4
opt.showmatch = true
opt.wrap = true
opt.cursorline = false
opt.visualbell = false
opt.signcolumn = 'yes'
opt.wildmenu = true
vim.opt.termguicolors = true

-- Edit
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.shiftround = true

-- Others
opt.swapfile = false
opt.updatetime = 300


-- Window
opt.splitbelow = true
opt.splitright = true


-- Avoid automatically commenting when adding a new line
vim.cmd [[ autocmd FileType * setlocal formatoptions-=r ]]
vim.cmd [[ autocmd FileType * setlocal formatoptions-=o ]]
