---@diagnostic disable: undefined-global
require "options"
require "keymap"
require "filetype"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
    { import = "plugins" },
})

require "autocmds"
require "run"
require "x_palette"

-- Color settings should be at the bottom.
require "colors"
