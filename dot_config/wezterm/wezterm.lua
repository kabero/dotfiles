local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Dracula'
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.font = wezterm.font_with_fallback {
    { family = 'JetBrainsMono Nerd Font', weight = 'Light' },
    'Hiragino Maru Gothic ProN'
}
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.use_ime = true
config.font_size = 13.0
config.window_background_opacity = 0.98

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.colors = {
  background = '#100000',
  compose_cursor = '#2b3261',
}

return config
