{
  config,
  pkgs,
  inputs,
  self,
  lib,
  ...
}: let
  # relative path to /etc to place our inputs such as /etc/${inputsPath}/nixpkgs
  inputsPath = "nix/inputs";
  selfRegistry = {
    to = {
      path = self.outPath;
      type = "path";
    };
    from = {
      id = "pkgs";
      type = "indirect";
    };
    exact = true;
  };
in {
  system.configurationRevision = self.rev or null;

  nix = {
    # Only needed on nixos-21.11
    # package = nixUnstable;

    extraOptions = builtins.readFile ../nix.conf};

    # name "pkgs" for convenience, so tools will work with
    # nix shell pkgs#foo ; etc
    registry =
      {
        pkgs = selfRegistry;
      }
      // lib.mapAttrs' (name: value: {
        inherit name;
        value.flake = value;
      })
      inputs;

    nixPath = [
      "nixpkgs=/etc/nix/inputs/nixpkgs"
    ];
  };

  environment.etc."nix/inputs/nixpkgs".source = self.outPath;
  environment.variables.NIXPKGS_CONFIG = lib.mkForce "";
}
