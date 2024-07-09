{
  config,
  pkgs,
  userConfig,
  ...
}: {
  imports = [
    <home-manager/nixos>
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
      tree
      alejandra
      tmux
      dig
      git-lfs
      netcat
      fzf
      unzip
      firefox
      kate
      qbittorrent
      alacritty
      vscode
      docker
      nodejs_20
      yarn
      conda
      discord
      slack
      zoom-us
      spotify
      awscli2
      aws-sam-cli
      libreoffice
      calibre
      obs-studio
      obsidian
      gimp
      digikam
      libsForQt5.bismuth
      libsForQt5.ghostwriter
      kdePackages.plasma-sdk
      github-copilot-cli
    ];
  };

  home-manager.useGlobalPkgs = true;

  home-manager.users.${userConfig.mainUserName} = {pkgs, ...}: {
    imports = [
      <plasma-manager/modules>
    ];

    programs.git = {
      enable = true;
      userName = userConfig.gitUserName;
      userEmail = userConfig.gitUserEmail;
      lfs.enable = true;
      extraConfig = {
        core.editor = "vim";
        push = {autoSetupRemote = true;};
        init.defaultBranch = "main";
      };
    };

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.vscode-pylance
        ms-toolsai.jupyter
        bmewburn.vscode-intelephense-client
        github.copilot
      ];
    };

    programs.qutebrowser = {
      enable = true;
      enableDefaultBindings = true;
    };

    programs.eza = {
      enable = true;
      enableBashIntegration = true;
      extraOptions = [
        "--group-directories-first"
      ];
      git = true;
      icons = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        size = "du -sh";
        light = "/home/${userConfig.mainUserName}/nixos-config/scripts/lightmode.sh";
        dark = "/home/${userConfig.mainUserName}/nixos-config/scripts/darkmode.sh";
        rebuild = "/home/${userConfig.mainUserName}/nixos-config/scripts/rebuild";
        repos = "gh repo list --no-archived";
        sail = "./vendor/bin/sail";
      };
      oh-my-zsh = {
        enable = true;
        theme = "af-magic";
        plugins = [
          "git"
          "docker"
          "aws"
          "yarn"
        ];
      };
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
    };

    programs.alacritty.settings = {
      import = [
        "~/themes/themes/gruvbox_dark.toml"
      ];
    };
    programs.tmux = {
      enable = true;
      prefix = "C-space";
      plugins = with pkgs.tmuxPlugins; [
        gruvbox
      ];
    };
    home.file."themes".source = builtins.fetchGit {
      url = "https://github.com/alacritty/alacritty-theme.git";
    };
    home.stateVersion = "23.11";
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
