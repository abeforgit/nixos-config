{ pkgs, config, lib, activitywatch, ... }:
with lib;
let cfg = config.custom.wezterm;
in {
  options.custom.wezterm = {
    enable = mkOption {
      example = true;
      default = false;

    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ wezterm ];

      xdg.configFile.weztermStylix = with config.lib.stylix.colors.withHashtag; {

          target = "wezterm/stylix.lua";
          text = ''
         local wezterm = require 'wezterm';
         return {

             font = wezterm.font "${config.stylix.fonts.monospace.name}",
             font_size = 14,
             window_frame = {
                 font = wezterm.font { family = '${config.stylix.fonts.monospace.name}', weight = 'Bold' },
                 font_size = 14,

                 -- The overall background color of the tab bar when
                 -- the window is focused
                 active_titlebar_bg = '${base00}',

                 -- The overall background color of the tab bar when
                 -- the window is not focused
                 inactive_titlebar_bg = '${base00}',
             },
             colors = {
                 -- The default text color
                 foreground = '${base05}',
                 -- The default background color
                 background = '${base00}',

                 -- Overrides the cell background color when the current cell is occupied by the
                 -- cursor and the cursor style is set to Block
                 cursor_bg = '${base05}',
                 -- Overrides the text color when the current cell is occupied by the cursor
                 cursor_fg = '${base00}',
                 -- Specifies the border color of the cursor when the cursor style is set to Block,
                 -- or the color of the vertical or horizontal bar when the cursor style is set to
                 -- Bar or Underline.
                 cursor_border = '${base05}',

                 -- the foreground color of selected text
                 selection_fg = '${base00}',
                 -- the background color of selected text
                 selection_bg = '${base05}',

                 -- The color of the scrollbar "thumb"; the portion that represents the current viewport
                 scrollbar_thumb = '#222222',

                 -- The color of the split lines between panes
                 split = '#444444',

                 ansi = {
                     '${base00}',
                     '${base08}',
                     '${base0B}',
                     '${base0A}',
                     '${base0D}',
                     '${base0E}',
                     '${base0C}',
                     '${base05}',
                 },
                 brights = {
                     '${base03}',
                     '${base09}',
                     '${base01}',
                     '${base02}',
                     '${base04}',
                     '${base06}',
                     '${base0F}',
                     '${base07}',
                 },

                 -- Arbitrary colors of the palette in the range from 16 to 255
                 indexed = { [136] = '#af8700' },

                 -- Since: 20220319-142410-0fcdea07
                 -- When the IME, a dead key or a leader key are being processed and are effectively
                 -- holding input pending the result of input composition, change the cursor
                 -- to this color to give a visual cue about the compose state.
                 compose_cursor = 'orange',

                 -- Colors for copy_mode and quick_select
                 -- available since: 20220807-113146-c2fee766
                 -- In copy_mode, the color of the active text is:
                 -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
                 -- 2. selection_* otherwise
                 copy_mode_active_highlight_bg = { Color = '#000000' },
                 -- use `AnsiColor` to specify one of the ansi color palette values
                 -- (index 0-15) using one of the names "Black", "Maroon", "Green",
                 --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
                 -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
                 copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
                 copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
                 copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

                 quick_select_label_bg = { Color = 'peru' },
                 quick_select_label_fg = { Color = '#ffffff' },
                 quick_select_match_bg = { AnsiColor = 'Navy' },
                 quick_select_match_fg = { Color = '#ffffff' },
                 tab_bar = {
                     -- The color of the inactive tab bar edge/divider
                     inactive_tab_edge = '#575757',
                     -- The color of the strip that goes along the top of the window
                     -- (does not apply when fancy tab bar is in use)
                     background = '${base00}',

                     -- The active tab is the one that has focus in the window
                     active_tab = {
                         -- The color of the background area for the tab
                         bg_color = '${base01}',
                         -- The color of the text for the tab
                         fg_color = '${base05}',

                         -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
                         -- label shown for this tab.
                         -- The default is "Normal"
                         intensity = 'Normal',

                         -- Specify whether you want "None", "Single" or "Double" underline for
                         -- label shown for this tab.
                         -- The default is "None"
                         underline = 'None',

                         -- Specify whether you want the text to be italic (true) or not (false)
                         -- for this tab.  The default is false.
                         italic = false,

                         -- Specify whether you want the text to be rendered with strikethrough (true)
                         -- or not for this tab.  The default is false.
                         strikethrough = false,
                     },

                     -- Inactive tabs are the tabs that do not have focus
                     inactive_tab = {
                         bg_color = '${base00}',
                         fg_color = '${base04}',

                         -- The same options that were listed under the `active_tab` section above
                         -- can also be used for `inactive_tab`.
                     },

                     -- You can configure some alternate styling when the mouse pointer
                     -- moves over inactive tabs
                     inactive_tab_hover = {
                         bg_color = '${base01}',
                         fg_color = '${base0D}',
                         italic = true,

                         -- The same options that were listed under the `active_tab` section above
                         -- can also be used for `inactive_tab_hover`.
                     },

                     -- The new tab button that let you create new tabs
                     new_tab = {
                         bg_color = '${base00}',
                         fg_color = '${base04}',

                         -- The same options that were listed under the `active_tab` section above
                         -- can also be used for `new_tab`.
                     },

                     -- You can configure some alternate styling when the mouse pointer
                     -- moves over the new tab button
                     new_tab_hover = {
                         bg_color = '${base03}',
                         fg_color = '${base0D}',
                         italic = true,

                         -- The same options that were listed under the `active_tab` section above
                         -- can also be used for `new_tab_hover`.
                     },
                 }
             }
         }
          '';
      };
      # xdg.configFile.weztermConfig = {
      #   source = ./wezterm/wezterm.lua;
      #   target = "wezterm/wezterm.lua";


      # };
    };
  };
}
