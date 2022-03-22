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
python311
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
networkmanagerapplet
pa_applet
papirus-icon-theme
luna-icons
marwaita
lxappearance
psmisc
vscodium-fhs
obs-studio
steam
    ];
services.betterlockscreen.enable = true;
services.picom.enable = true;
services.picom.fade = true;
services.picom.backend = "glx";
services.picom.vSync = true;
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
programs.kitty.environment = {
        "shell" = "zsh";
        "editor" = "nvim";
        "shell_integration" = "enabled";
    };
programs.kitty.settings = {
font_family = "Iosevka Nerd Font";
window_padding_width = 15;
url_style = "single";
};
programs.kitty.extraConfig = "include theme.conf";
}
