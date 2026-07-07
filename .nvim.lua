-- Project tasks for the chezmoi source repo (:Run <name> — see init.lua).
-- `%` expands to the file being edited, i.e. the chezmoi SOURCE path;
-- target-path turns it into the deployed path for scoped apply/diff.
local t = RunTasks

-- Bare :Run / <leader>q — apply just the file being edited. No --force on
-- purpose: "target has changed" conflicts (herdr writes into its own
-- config.toml) should surface, not be clobbered.
t.default = 'chezmoi apply $(chezmoi target-path %)'

t.diff    = 'chezmoi diff $(chezmoi target-path %)'
t.diffall = 'chezmoi diff'

-- The two edit loops with a step after apply. The lua form avoids "+Lazy!
-- sync" because :! expands a bare ! to the previous shell command.
t.nvim  = [[chezmoi apply ~/.config/nvim && nvim --headless "+lua require('lazy').sync({wait=true, show=false})" +qa]]
t.herdr = 'chezmoi apply ~/.config/herdr/config.toml && herdr server reload-config'
