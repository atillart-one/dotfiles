{
  config,
  pkgs,
  inputs,
  self,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs self;};
    # Add more home-manager modules here
    sharedModules = [
      ../hm-modules/base.nix
    ];
    # Empty config so home-manager manages our user
    users.nix = _: {};
  };
}
