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
vim.api.nvim_set_keymap("n", "]b", ":<c-u>bnext<CR>", opts)
vim.api.nvim_set_keymap("n", "[b", ":<c-u>bprev<CR>", opts)
vim.api.nvim_set_keymap("n", "<c-l>", ":<c-u>noh<CR><c-l>", opts)

-- open init.vim in chezmoi dir
vim.api.nvim_set_keymap("n", "<leader>,", ":execute 'edit ' .. luaeval('GetNVimConfigPath()')<CR> :execute 'lcd ' .. luaeval('GetChezmoiDir()')<CR>", opts)

-- Insert
------------------------------------

-- Visual
------------------------------------

-- Command
------------------------------------

-- Terminal
------------------------------------
vim.cmd [[
    tnoremap <Esc> <C-\><C-n>
    tnoremap <c-[> <C-\><C-n>
]]
