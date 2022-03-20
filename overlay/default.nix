final: prev: {
  awesome = (prev.awesome.overrideAttrs (old: rec {
    version = "unstable-2022-03-06";
    src = prev.fetchFromGitHub {
      owner = "awesomeWM";
      repo = "awesome";
      rev = "392dbc21ab6bae98c5bab8db17b7fa7495b1e6a5";
      hash = "sha256-GD0MxMU4tz5SbahL0+ADUQXNoq1fIxOSXiEwoObC0ng="; 
    };
    GI_TYPELIB_PATH = "${prev.playerctl}/lib/girepository-1.0:"
      + "${prev.upower}/lib/girepository-1.0:" + old.GI_TYPELIB_PATH;
  })).override {
    gtk3Support = true;
  };
}
