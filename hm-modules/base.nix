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
(nerdfonts.override { fonts = [ "Iosevka" "SourceCodePro"]; })
montserrat
overpass
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
vscodium-fhs
obs-studio
steam
ripgrep
xsettingsd
xorg.xwininfo
obsidian
logseq
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
    name = "Phinger-Cursors";
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
corner-radius = 12;
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

# ZSH
programs.zsh.enable = true; 
programs.zsh.prezto.enable = true;
programs.zsh.prezto.prompt.theme = "powerlevel10k";
programs.zsh.prezto.pmodules = [ "environment" "terminal" "editor" "history" "directory" "spectrum" "utility" "syntax-highlighting" "history-substring-search" "autosuggestions" "archive" "completion" "prompt" ];
programs.zsh.initExtra = "alias vi='nvim'
autoload -Uz promptinit
promptinit
prompt powerlevel10k 
# To customize prompt, run p10k configure or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";

# Kitty
programs.kitty.enable = true;
programs.kitty.environment = {
        "shell" = "zsh";
        "editor" = "nvim";
        "shell_integration" = "enabled";
    };
programs.kitty.settings = {
font_family = "Iosevka Nerd Font";
window_padding_width = 15;
url_style = "single";
allow_remote_control = "yes";
};
programs.kitty.extraConfig = "
cursor #f0f0f0
cursor_text_color #ffffff
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

foreground            #f0f0f0
background            #0f0f0f
selection_foreground  #262626
selection_background  #f0f0f0
url_color             #c6a679
#background_opacity  0.98

# black
color8   #262626
color0   #4c4c4c

# red
color1   #ac8a8c
color9   #c49ea0

# green
color2   #8aac8b
color10  #9ec49f

# yellow
color3   #aca98a
color11  #c4c19e

# blue
color4  #8f8aac
color12 #a39ec4

# magenta
color5   #ac8aac
color13  #c49ec4

# cyan
color6   #8aacab
color14  #9ec3c4

# white
color15   #e7e7e7
color7  #f0f0f0
";
}
