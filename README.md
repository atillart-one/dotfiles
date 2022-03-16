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

## Common workflow

Note: adding any new file requires that it is git tracked `$ git add -N .`

### Configuring NixOS

Either modify any file in `nixos-modules`, or create a new one and add it to `flake.nix`.
You can find configuration options in [search.nixos.org/options](https://search.nixos.org/options?).

```nix
{
   config,
   pkgs,
   ...
}:
{
   option = "value";
}
```

### Configuring home-manager

Either modify any file in `hm-modules`, or create a new one and add it to `nixos-modules/home-manager.nix`.

```nix
{
   config,
   pkgs,
   ...
}:
{
   option = "value";
}
```

You can find configuration options in [rycee.gitlab.io/home-manager/options.html](https://rycee.gitlab.io/home-manager/options.html).

### Mutable configuration files

Everything installed by this flake is immutable, but many times you will want something to be editable. You can set a systemd-tmpfile rule to link config files from this flake to their place, such as:

```nix
# hm-modules/vscode.nix
{
   config,
   pkgs,
   ...
}:
{
   systemd.user.tmpfiles.rules = [
      "L+ /home/USER/.config/Code/User/settings.json - - - - /home/USER/nixfiles/config/vscode/settings.json"
   ];
}
```

### Overriding a package

In nix, you can patch any package to change its source code, or change any phase in the compile+install process.
These "overrides" can be set at any place, but an overlay is a file that can hold many overrides, and propagate them to
your whole flake.

```nix
# overlay/default.nix
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
```

## Things to avoid

- `nix-env` command as a whole. If you previously installed stuff with it, you can remove everything with:
  ```console
  $  nix-env -e '.*'
  ```
  To "install" something temporall, use `nix shell pkgs#packageName`.
- `nix-channel`. This command pre-dates flakes, and serves the purpose of manipulating your `NIX_PATH` environment variable to set `nixpkgs`. With this config, we setup `NIX_PATH` to the nixpkgs defined in our flake, so this tool is rendered useless.
- Configure your nixpkgs in `flake.nix` (at legacyPackages). Avoid the NixOS / home-manager option `nixpkgs.config` or dropping files in `~/.config/nixpkgs/config.nix`.
