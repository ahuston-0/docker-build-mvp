{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./docker
  ];

  networking = {
    hostName = "test-machine";
    hostId = "dc2f9781";
  };

  boot = {
    loader.grub.device = "/dev/sda";
    kernelParams = [
      "i915.force_probe=56a5"
      "i915.enable_guc=2"
    ];
    kernel.sysctl = {
      "vm.overcommit_memory" = lib.mkForce 1;
      "vm.swappiness" = 10;
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime
        intel-media-sdk
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    intel-gpu-tools
    jellyfin-ffmpeg
    jq
  ];

  virtualisation.docker = {
    enable = lib.mkDefault true;
    logDriver = "local";
    storageDriver = "overlay2";
    daemon.settings = {
      experimental = true;
      exec-opts = [ "native.cgroupdriver=systemd" ];
      log-opts = {
        max-size = "10m";
        max-file = "5";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  gc.options = "--delete-older-than 150d";
  };



  system.stateVersion = "23.05";
}
