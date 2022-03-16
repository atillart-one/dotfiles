This is a template for a NixOS system managed with a flake. It also includes home-manager and a sample overlay.

## Installation

0. Install NixOS the conventional way

1. Clone this repo wherever:
   ```console
   git clone https://github.com/viperML/nixos-flakes ~/nixfiles
   cd ~/nixfiles
   ```

2. Enter the pre-configured nix shell, that enables flake support:
   ```console
   nix-shell
   ```

3. Follow the instructions that will be printed to the console

## Features

- `legacyPackages` output. By exposing the nixpkgs that has been imported and configured, you can build
  packages affected by your overlay just by using `nix build .#my-package` or `nix-build -A my-package` (thanks to flake-compat).
- `NIX_PATH` set to the `legacyPackages` output. For the same reasoning, the system will use a uniform `nixpkgs`       configuration, so you don't have to edit `~/.config/nixpkgs/config.nix`. It also allows you to run unfree packages with nix flake commands, such as `nix run pkgs#discord`.
- Sample overlay in `./overlay/default.nix`. An overlay allows you declare modifications to packages, in a similar fashion to Gentoo's patching.
