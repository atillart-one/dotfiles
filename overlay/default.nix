final: prev: {
  awesome = (prev.awesome.overrideAttrs (old: rec {
    version = "unstable-2022-03-06";
    src = prev.fetchFromGitHub {
      owner = "awesomeWM";
      repo = "awesome";
      rev = "392dbc21ab6bae98c5bab8db17b7fa7495b1e6a5";
      hash = "sha256-JpG7tOtIfElDB4xjcjBFC4fE6Z0loZtP1mP8UOVVfyQ="; 
    };
    GI_TYPELIB_PATH = "${prev.playerctl}/lib/girepository-1.0:"
      + "${prev.upower}/lib/girepository-1.0:" + old.GI_TYPELIB_PATH;
  })).override {
    gtk3Support = true;
  };
  picom = prev.picom.overrideAttrs (prevAttrs: {
    version = "unstable-2021-10-23";
    src = prev.fetchFromGitHub {
      owner = "pijulius";
      repo = "picom";
      rev = "982bb43e5d4116f1a37a0bde01c9bda0b88705b9";
      hash = "sha256-YiuLScDV9UfgI1MiYRtjgRkJ0VuA1TExATA2nJSJMhM=";
    };
  });
}
