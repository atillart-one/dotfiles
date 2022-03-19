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
iosevka
neofetch
htop
gtop
neovim
cava
    ];
services.picom.enable = true;
services.picom.fade = true;
services.flameshot.enable = true;
fonts.fontconfig.enable = true;
programs.zsh.enable = true; 
programs.kitty.enable = true;
programs.zsh.prezto.enable = true; 
programs.kitty.settings = {
font_family = "Iosevka";
bold_font = "auto";
italic_font = "auto";
bold_italic_font = "auto";
foreground = "#E8E3E3";
background = "#151515";
url_color = "#E8E3E3";
color0 = "#151515";
color8 = "#424242";
color1 = "#B66467";
color9 = "#B66467";
color2 = "#8C977D";
color10 = "#8C977D";
color3 = "#D9BC8C";
color11 = "#D9BC8C";
color4 = "#8DA3B9";
color12 = "#8DA3B9";
color5 = "#A988B0";
color13 = "#A988B0";
color6 = "#8AA6A2";
color14 = "#8AA6A2";
color7 =  "#E8E3E3";
color15 =  "#E8E3E3";
};
}
