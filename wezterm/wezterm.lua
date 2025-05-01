-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'GitHub Dark'
config.colors = {
  tab_bar = {
    background = '#0d1117', -- GitHub dark background color

    -- Active tab style
    active_tab = {
      bg_color = '#238636', -- GitHub green for active items
      fg_color = '#f0f6fc', -- GitHub light text
    },

    -- Inactive tab style
    inactive_tab = {
      bg_color = '#161b22', -- GitHub dark secondary background
      fg_color = '#8b949e', -- GitHub muted text color
    },

    -- Tab hover styles
    inactive_tab_hover = {
      bg_color = '#161b22',
      fg_color = '#58a6ff', -- GitHub blue
    },

    -- New tab button style
    new_tab = {
      bg_color = '#0d1117',
      fg_color = '#58a6ff', -- GitHub blue
    },

    -- New tab hover style
    new_tab_hover = {
      bg_color = '#0d1117',
      fg_color = '#58a6ff', -- GitHub blue
      intensity = 'Bold',
    },
  },
}

-- These options can be adjusted to your preference
config.use_fancy_tab_bar = false -- Set to false for a more minimal tab bar
config.window_decorations = 'RESIZE' -- Removes the title bar but keeps resize capability

config.font = wezterm.font 'JetBrainsMono Nerd Font'
-- config.font = wezterm.font_with_fallback({
--	"JetBrainsMono Nerd Font",
--	{ family = "Symbols Nerd Font Mono", scale = 2 },
--})
config.window_decorations = 'TITLE | RESIZE'
config.initial_cols = 120
config.initial_rows = 30

-- and finally, return the configuration to wezterm
return config
