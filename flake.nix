{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs self;
      };
      pkgs = self.legacyPackages."x86_64-linux";
      modules = [
        ./nixos-modules/configuration.nix
        ./nixos-modules/hardware-configuration.nix
        ./nixos-modules/base.nix
        # Add more nixos modules here

        # Home manager as NixOS module
        inputs.home-manager.nixosModules.home-manager
        # Add more home-manager modules *inside* the file
        ./nixos-modules/home-manager.nix
      ];
    };

    legacyPackages."x86_64-linux" = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
      overlays = [
        (import ./overlay)
      ];
    };

    devShells."x86_64-linux".default = with self.legacyPackages."x86_64-linux";
      mkShell
      {
        name = "bootstrap-shell";
        packages = [
          # use our nix package that supports flakes
          nix
          git
        ];
        shellHook = ''
          echo ""
          echo "Welcome to the bootstrap shell!"
          echo "Inside this shell you have access to flakes before we enabled them systemd-wide"
          echo "- Update to the latest nixpkgs"
          echo "  $ nix flake update"
          echo "- Move your config to this flake"
          echo "  $ sudo mv /etc/nixos/configuration.nix $PWD/nixos-modules/"
          echo "  $ sudo mv /etc/nixos/hardware-configuration.nix $PWD/nixos-modules/"
          echo "  $ sudo chown -R $USER:$(id -gn) nixos-modules"
          echo "- Edit flake.nix and change nixos for your hostname"
          echo "  $ sed -i 's/nixos/$(cat /etc/hostname)/g' $PWD/flake.nix"
          echo "- Edit ./nixos-modules/home-manager.nix and change USER for your user"
          echo "  $ sed -i 's/USER/$USER/g' $PWD/nixos-modules/home-manager.nix"
          echo "- Install"
          echo "  $ sudo -E nixos-rebuild switch --flake $PWD"
          echo ""
        '';
        NIX_USER_CONF_FILES = "${./nix.conf}";
      };
  };
}
