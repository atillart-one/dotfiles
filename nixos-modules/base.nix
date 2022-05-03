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

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

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
  
  nixpkgs.config.allowUnfree = true;
  
  #NVIDIA
  environment.systemPackages = [ nvidia-offload ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

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
  time.timeZone = "Asia/Kolkata";

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  programs.dconf.enable = true;
  services.xserver.windowManager.awesome.enable = true;

  # OpenGL
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true; 
  hardware.opengl.driSupport = true;

  programs.git.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  services.upower.enable = true;
}

