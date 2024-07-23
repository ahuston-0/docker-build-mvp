{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./nextcloud.nix
  ];

  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker.daemon.settings.data-root = "/var/lib/docker2";
}
