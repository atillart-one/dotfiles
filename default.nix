# Based on https://github.com/NixOS/nixpkgs/blob/7f9b6e2babf232412682c09e57ed666d8f84ac2d/pkgs/top-level/impure.nix
{
  localSystem ? {system = args.system or builtins.currentSystem;},
  system ? localSystem.system,
  crossSystem ? localSystem,
  ...
} @ args: let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  flake-compat = fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash;
  };
  flake = import flake-compat {src = ./.;};
  pkgs = flake.defaultNix.legacyPackages.${system};
in
  # If `localSystem` was explicitly passed, legacy `system` should
  # not be passed, and vice-versa.
  assert args ? localSystem -> !(args ? system);
  assert args ? system -> !(args ? localSystem); pkgs
