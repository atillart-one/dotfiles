{
  config,
  pkgs,
  lib,
  inputs,
  self,
  ...
}: {
  home.file.".nix-inputs/nixpkgs".source = self.outPath;
  home.sessionVariables.NIX_PATH = "nixpkgs=${config.home.homeDirectory}/.nix-inputs/nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
  home.activation.useFlakeChannels = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-defexpr
    $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-defexpr
    $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-channels
    $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-channels
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG /dev/null $HOME/.config/nixpkgs
  '';

  home.file = {
    ".config/awesome".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/awesome";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/NvChad";
    ".config/betterlockscreenrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/betterlockscreenrc";
  };
home.packages = with pkgs; [ 
(nerdfonts.override { fonts = [ "Iosevka" ]; })
inconsolata
mplus-outline-fonts.githubRelease
montserrat
inter
neofetch
htop
gtop
neovim
cava
playerctl
gcc
python310
python310Packages.pip
nodejs
nodePackages.npm
rofi
ranger
w3m
feh
xfce.thunar
xfce.tumbler
discord
betterdiscordctl
xarchiver
unzip
rar
gzip
networkmanagerapplet
pa_applet
lxappearance
psmisc
obs-studio
steam
ripgrep
xorg.xwininfo
obsidian
logseq
pavucontrol
gnome.gnome-power-manager
cbatticon
    ];

services.mpris-proxy.enable = true;
services.blueman-applet.enable = true;
services.betterlockscreen.enable = true;

# Firefox

programs.firefox = {
    enable = true;
    profiles = {
        nix = {
            isDefault = true;
            userChrome = "
            /* taken from https://github.com/Neikon/AutoColor-Minimal-Proton */

/* Custom tab active color */
.tab-background[selected=\"true\"] {
  background: #ffffff05 !important;
} 

/* rework of container line
.tab-context-line{margin-top: 1px !important; max-height: 1px !important; }
.tab-context-line{-moz-box-ordinal-group: 1 !important; opacity: 1 !important;transition: none !important;}
*/

/* Glowing line at top. */
.tabbrowser-tab > .tab-stack > .tab-background > .tab-context-line
{
	background-color: var(--identity-icon-color) !important;
	height: 1px !important;
	border-radius: 1px !important;
	margin: var(--tab-border-radius) var(--tab-border-radius) 0px !important;
	box-shadow: 0px 3px 9px 0px var(--identity-icon-color) !important;
  
}
.tabbrowser-tab > .tab-stack > .tab-background
{
    border-width: 0px !important;
    border-radius: 0px 0px 0px 0px !important;
}
/* URLBar*/
#urlbar:not([focused=\"true\"]) > #urlbar-background {
  border-radius: 0px;
	background: #ffffff05 !important;
  box-shadow: 0px 0px 4px 0px hsla(240,5%,5%,0.3) !important;
}
#urlbar[open] > #urlbar-background{
  border: none !important;
  box-shadow: 0px 0px 4px 0px rgb(12, 12, 13) !important;
}

#urlbar {
	text-align: center !important;
}
/* Source below from https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_bookmarks_and_main_toolbars.css */
/* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_bookmarks_and_main_toolbars.css made available under Mozilla Public License v. 2.0
See the above repository for updates as well as full license text. */

#navigator-toolbox{
  --uc-bm-padding: 4px; /* Vertical padding to be applied to bookmarks */
  --uc-bm-height: calc(20px + 2 * var(--uc-bm-padding)); /* Might need to adjust if the toolbar has other buttons */
  --uc-navbar-height: -40px; /* navbar is main toolbar. Use negative value */
  --uc-autohide-toolbar-delay: 600ms; /* The toolbar is hidden after 0.6s */
}



:root[uidensity=\"compact\"] #navigator-toolbox{
  --uc-bm-padding: 1px;
  --uc-navbar-height: -34px;
}
:root[uidensity=\"touch\"] #navigator-toolbox{ --uc-bm-padding: 6px }

:root[sessionrestored] #nav-bar,
:root[sessionrestored] #PersonalToolbar{
  background-image: linear-gradient(var(--toolbar-bgcolor),var(--toolbar-bgcolor)), var(--lwt-additional-images,var(--toolbar-bgimage))  !important;
  background-position: top,var(--lwt-background-alignment);
  background-position-y: calc(0px - var(--tab-min-height) - 2*var(--tab-block-margin,0px));
  background-repeat: repeat,var(--lwt-background-tiling);
  transform: rotateX(90deg);
  transform-origin: top;
  transition: transform 135ms linear var(--uc-autohide-toolbar-delay) !important;
  z-index: 2;
}

:root[sessionrestored] #PersonalToolbar{
  z-index: 1;
  background-position-y: calc(0px - var(--tab-min-height) - 2*var(--tab-block-margin,0px) + var( --uc-navbar-height));
}

:root[lwtheme-image] #nav-bar,
:root[lwtheme-image] #PersonalToolbar{
  background-image: linear-gradient(var(--toolbar-bgcolor),var(--toolbar-bgcolor)),var(--lwt-header-image), var(--lwt-additional-images,var(--toolbar-bgimage)) !important;
}

#nav-bar[customizing],#PersonalToolbar[customizing]{ transform: none !important }

#navigator-toolbox > #PersonalToolbar{
  transform-origin: 0px var(--uc-navbar-height);
  position: relative;
}

:root[sessionrestored]:not([customizing]) #navigator-toolbox{
  margin-bottom:  calc(0px - var(--uc-bm-height) + var(--uc-navbar-height));
}
#PlacesToolbarItems > .bookmark-item {
  min-height: calc(var(--uc-bm-height) - 4px); /* Bookmarks have 2px block margin */
  padding-block: 0px !important;
}

#OtherBookmarks,
#PlacesChevron,
#PersonalToolbar > #import-button{
  padding-block: var(--uc-bm-padding) !important;
}

/* Make sure the bookmarks toolbar is never collapsed even if it is disabled */
:root[sizemode=\"fullscreen\"] #PersonalToolbar,
#PersonalToolbar[collapsed=\"true\"]{
  min-height: initial !important;
  max-height: initial !important;
  visibility: hidden !important
}
#PersonalToolbar[collapsed=\"true\"] #PlacesToolbarItems > *,
:root[sizemode=\"fullscreen\"] #PersonalToolbar #PlacesToolbarItems > *{
  visibility: hidden !important;
}

/* The invisible toolbox will overlap sidebar so we'll work around that here */
#navigator-toolbox{ pointer-events: none; border-bottom: none !important; }
#PersonalToolbar{ border-bottom: 1px solid var(--chrome-content-separator-color) }
#navigator-toolbox > *{ pointer-events: auto }

#sidebar-box{ position: relative }

/* Selected tab needs higher z-index now to hide the broder below it */
.tabbrowser-tab[selected]{ z-index: 3 !important; }

/* Center tab text */
.tab-label-container.proton { display: grid !important; justify-items: safe center !important; } .tab-label { overflow: hidden !important; } 

/* SELECT TOOLBAR BEHAVIOR */
/* Comment out or delete one of these to disable that behavior */

/* Show when urlbar is focused */
#nav-bar:focus-within + #PersonalToolbar,
#navigator-toolbox > #nav-bar:focus-within{
  transition-delay: 100ms !important;
  transform: rotateX(0);
}

/* Show when cursor is over the toolbar area */
#navigator-toolbox:hover > .browser-toolbar{
  transition-delay: 100ms !important;
  transform: rotateX(0);
}
/* This makes the tab notification box show immediately below tabs, otherwise it would break the layout */
#navigator-toolbox > div{ display: contents }
:where(#titlebar,#tab-notification-deck,.global-notificationbox){
  -moz-box-ordinal-group: 0;
}
/* Show when cursor is over popups/context-menus - cannot control which ones */
/*
#mainPopupSet:hover ~ box > toolbox > .browser-toolbar{
  transition-delay: 100ms !important;
  transform: rotateX(0);
}
*/

/* Uncomment the next part to enable compatibility for multi-row_bookmarks.css
 * This would break buttons placed in the toolbar,
 * but that is likely not happening if you are using multi-row setup
 */
 
/*
#navigator-toolbox{ margin-bottom: var(--uc-navbar-height) !important; }
#PersonalToolbar:not([customizing]){
  position: fixed !important;
  display: block;
  margin-bottom: 0px !important;
}
*/
            ";

            userContent = "
            /* dark blank tab */
u/-moz-document url(about:blank), url(about:newtab) {
	#newtab-window, html:not(#ublock0-epicker) {
		background: #222 !important;
	}
}
            ";

            settings = {
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "widget.gtk.overlay-scrollbars.enabled" = true;
                "ui.prefersReducedMotion" = "1";
              };
          };
      };
  }

# GTK
gtk = {
  enable = true;

  # Theme
  theme = {
    package = pkgs.orchis-theme.override { tweaks = [ "black" "compact" ];};
    name = "Orchis-dark-compact";
  };
  
  # Icons
  iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };

  # Cursor
  cursorTheme = {
    package = pkgs.phinger-cursors;
    name = "Phinger Cursors";
  };
};


# Picom
services.picom.enable = true;
services.picom.fade = true;
services.picom.backend = "glx";
services.picom.vSync = true;
services.picom.shadow = true;
services.picom.blurExclude = [
  "window_type = 'dock'"
  "window_type = 'desktop'"
  "window_type = 'menu'"
  "window_type = 'dropdown_menu'"
  "window_type = 'popup_menu'"
  "window_type = 'utility'"
  "window_type = 'tooltip'"
  "name = 'rofi - drun'"
];
services.picom.shadowExclude = [
  "name = 'Notification'"
  "class_g = 'Conky'"
  "class_g ?= 'Notify-osd'"
  "class_g = 'Cairo-clock'"
  "_GTK_FRAME_EXTENTS@:c"
  "window_type = 'popup_menu'"
  "window_type = 'utility'"
  "window_type = 'tooltip'"
  "name = 'rofi - drun'"
];
services.picom.extraOptions = "
corner-radius = 0;
shadow-opacity = 0.9;
detect-transient = true;
detect-client-leader = true;
animations = true;
animation-for-open-window = \"slide-up\";
animation-for-unmap-window = \"slide-down\";
";

services.flameshot.enable = true;
fonts.fontconfig.enable = true;
programs.zathura.enable = true;

# Shell
programs.zsh.enable = true; 
programs.starship.enable = true;
programs.starship.enableZshIntegration = true;
programs.zsh.prezto.enable = true;
programs.zsh.prezto.pmodules = [ "environment" "terminal" "editor" "history" "directory" "spectrum" "utility" "syntax-highlighting" "history-substring-search" "autosuggestions" "archive" "completion" "prompt" ];
programs.zsh.initExtra = "alias vi='nvim'";
# Kitty
programs.kitty.enable = true;
programs.kitty.environment = {
        "shell" = "zsh";
        "editor" = "nvim";
        "shell_integration" = "enabled";
    };
programs.kitty.settings = {
font_family = "M PLUS 1 Code";
window_padding_window_padding_widthh = 15;
url_style = "single";
allow_remote_control = "yes";
};
programs.kitty.extraConfig = "
font_size 12
cursor_shape block

cursor_blink_interval 0.5
cursor_stop_blinking_after 0

scrollback_lines 5000

url_color #0f0f0f
url_style single

repaint_delay 10
input_delay 3

sync_to_monitor yes

enable_audio_bell no

remember_window_size no

window_padding_width 20.0

#background_opacity  0.98

background #0d1117
foreground #aeb6be
selection_background #163356
selection_foreground #b3b1ad
url_color #b3b1ad

cursor #c0caf5

# Tabs
active_tab_background #7aa2f7
active_tab_foreground #1f2335
inactive_tab_background #292e42
inactive_tab_foreground #545c7e
#tab_bar_background #15161E

# normal
color0 #8b949e
color1 #ff7b72
color2 #9ece6a
color3 #f78166
color4 #79c0ff
color5 #d2a8ff
color6 #a5d6ff
color7 #f0f6fc

# bright
color8 #8b949e
color9 #ff7b72
color10 #9ece6a
color11 #f78166
color12 #79c0ff
color13 #d2a8ff
color14 #a5d6ff
color15 #f0f6fc

# extended colors
color16 #ff9e64
color17 #db4b4b
";
}
