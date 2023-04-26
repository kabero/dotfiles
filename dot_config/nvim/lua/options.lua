-- General
vim.cmd("language C")
vim.cmd("set encoding=utf-8")
vim.cmd("let g:python3_host_prog = expand('/Users/ko_abe/.pyenv/versions/nvim3/bin/python')")
vim.cmd("let g:ruby_host_prog = expand('~/.rbenv/versions/3.0.6/bin/ruby')")
vim.opt.clipboard:append { 'unnamedplus' }
vim.opt.mouse = 'a'
vim.opt.fileformats = 'unix'
vim.opt.ambiwidth = "single"

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- View
vim.opt.cursorline = false
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.ruler = true
vim.opt.showmatch = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.visualbell = false
vim.opt.wildmenu = true
vim.opt.wrap = true
vim.opt.showtabline = 2

-- Edit
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.tabstop = 4

-- Others
vim.opt.swapfile = false
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.hidden = true

-- Window
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Avoid automatically commenting when adding a new line
vim.cmd [[ autocmd FileType * setlocal formatoptions-=r ]]
vim.cmd [[ autocmd FileType * setlocal formatoptions-=o ]]
