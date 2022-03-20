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
home.packages = with pkgs; [ 
(nerdfonts.override { fonts = [ "Iosevka" ]; })
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
python311
rofi
ranger
feh
xfce.thunar
discord
betterdiscordctl
xarchiver
unzip
rar
networkmanagerapplet
pa_applet
lxappearance
psmisc
    ];
services.picom.enable = true;
services.picom.fade = true;
services.picom.backend = "glx";
services.picom.shadow = true;
services.picom.extraOptions = "
corner-radius = 12
";
services.flameshot.enable = true;
fonts.fontconfig.enable = true;
programs.zsh.enable = true; 
programs.kitty.enable = true;
programs.zsh.prezto.enable = true;
programs.zsh.prezto.prompt.theme = "powerlevel10k";
programs.zsh.prezto.pmodules = [ "environment" "terminal" "editor" "history" "directory" "spectrum" "utility" "syntax-highlighting" "history-substring-search" "autosuggestions" "archive" "completion" "prompt" ];
programs.zsh.initExtra = "alias vim='nvim'
autoload -Uz promptinit
promptinit
prompt powerlevel10k 

# To customize prompt, run p10k configure or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";
programs.kitty.settings = {
font_family = "Iosevka Nerd Font";
window_padding_width = 15;
foreground = "#f0f0f0";
background = "#0f0f0f";
url_color = "#c6a679";
url_style = "single";
cursor = "#f0f0f0";
cursor_text_color = "#ffffff";
selection_foreground = "#262626";
selection_background = "#f0f0f0";

color8 = "#262626";
color0 = "#4c4c4c";

color1 = "#ac8a8c";
color9 = "#c49ea0";

color2 = "#8aac8b";
color10 = "#9ec49f";

color3 = "#aca98a";
color11 = "#c4c19e";

color4 = "#8f8aac";
color12 = "#a39ec4";

color5 = "#ac8aac";
color13 = "#c49ec4";

color6 = "#8aacab";
color14 = "#9ec3c4";

color15 = "#e7e7e7";
color7 = "#f0f0f0";
};
}
