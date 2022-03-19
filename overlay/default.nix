final: prev: {
  # Change the source code of awesomewm to the latest git commit, at the time of writing
  awesome = prev.awesome.overrideAttrs (prevAttrs: {
    version = "unstable-2022-03-06";
    src = prev.fetchFromGitHub {
      owner = "awesomeWM";
      repo = "awesome";
      rev = "392dbc21ab6bae98c5bab8db17b7fa7495b1e6a5";
      sha256 = "093zapjm1z33sr7rp895kplw91qb8lq74qwc0x1ljz28xfsbp496";
    };
  });
}
