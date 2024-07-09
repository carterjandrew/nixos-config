{
  config,
  pkgs,
  ...
}: let
  userConfig = import ./user-config.nix;
  configImport = import "/home/${userConfig.mainUserName}/nixos-config/config.nix" {inherit config pkgs userConfig;};
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    configImport
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
