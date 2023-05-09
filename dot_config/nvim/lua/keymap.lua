local opts = { noremap = true, silent = true }

-- helper
------------------------------------
GetChezmoiDir = function()
    local handle = io.popen("chezmoi source-path")
    if handle ~= nil then
        local result = handle:read('*a')
        handle:close()
        local chezmoi_dir = result:gsub("\n$", "")
        return chezmoi_dir
    end
    return nil
end

GetNVimConfigPath = function()
    local chezmoi_dir = GetChezmoiDir()
    if chezmoi_dir ~= nil then
        return chezmoi_dir .. "/dot_config/nvim/init.lua"
    end
    return nil
end

-- General
------------------------------------
vim.g.mapleader = " "

-- Normal
------------------------------------
vim.api.nvim_set_keymap("n", "j", "gj", opts)
vim.api.nvim_set_keymap("n", "k", "gk", opts)
vim.api.nvim_set_keymap("n", "<leader>,", ":e $MYVIMRC<CR>", opts)

vim.api.nvim_set_keymap("n", "n", "nzz", opts)
vim.api.nvim_set_keymap("n", "N", "Nzz", opts)

vim.api.nvim_set_keymap("n", "<c-[>", ":bp<CR>", opts)
vim.api.nvim_set_keymap("n", "<c-]>", ":bn<CR>", opts)

-- open init.vim in chezmoi dir
vim.api.nvim_set_keymap("n", "<leader>,", ":execute 'edit ' .. luaeval('GetNVimConfigPath()')<CR> :execute 'lcd ' .. luaeval('GetChezmoiDir()')<CR>", opts)

-- Insert
------------------------------------

-- Visual
------------------------------------
