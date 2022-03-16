{
  config,
  pkgs,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs self;};
    sharedModules = [
      ../hm-modules/base.nix
    ];
  };
}
