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
xsettingsd
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
