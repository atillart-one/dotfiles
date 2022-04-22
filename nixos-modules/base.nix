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

    extraOptions = builtins.readFile ../nix.conf;

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

  #GRUB
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    grub = {
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      # set $FS_UUID to the UUID of the EFI partition
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root 486A-5994
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      version = 2;
    };
  };

  # Time
  time.hardwareClockInLocalTime = true;
  
  # Bluetooth
  services.blueman.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  programs.dconf.enable = true;
  services.xserver.windowManager.awesome.enable = true;
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;
  programs.git.enable = true;
  programs.light.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  networking.networkmanager.enable = true;
  services.upower.enable = true;
}

