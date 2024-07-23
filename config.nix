{
  config,
  pkgs,
  userConfig,
  ...
}: let
  homePath = toString ./home.nix;
  homeImport = import homePath {inherit config pkgs userConfig;};
in {
  imports = [
    homeImport
  ];
  # Select linux kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  #services.xserver.displayManager.sddm.wayland.enable = true;
  #services.desktopManager.plasma6.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  nix.optimise.automatic = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.logind.lidSwitch = "ignore";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Wheel needs no password so sudo is ez
  security.sudo.wheelNeedsPassword = false;

  # Make sure we got zsh on the system
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userConfig.mainUserName} = {
    isNormalUser = true;
    description = userConfig.mainUserDescription;
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      nixpkgs-fmt
      wget
      deno
      xclip
      tree
      alejandra
      tmux
      dig
      git-lfs
      netcat
      ripgrep
      fzf
      unzip
      gcc
      firefox
      kate
      qbittorrent
      alacritty
      vscode
      docker
      nodejs_20
      esbuild
      yarn
      conda
      discord
      slack
      zoom-us
      spotify
      awscli2
      aws-sam-cli
      calibre
      obs-studio
      obsidian
      blender
      gimp
      digikam
      libsForQt5.bismuth
      libsForQt5.ghostwriter
      libsForQt5.plasma-sdk
      kdePackages.plasma-sdk
      libsForQt5.kcolorchooser
      github-copilot-cli
      qemu
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    gh
  ];

  # Docker enable
  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [userConfig.mainUserName];
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
