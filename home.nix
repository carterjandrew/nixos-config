{
  config,
  pkgs,
  userConfig,
  ...
}: {
  imports = [
    <home-manager/nixos>
  ];
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

    programs.neovim = {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
        vim.opt.runtimepath:append { '/home/carter/nvim' }
        lua require('init')
      '';
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
        open = "Dolphin";
        oo = "cd ~/personaldocs/notes";

        # Neovim and notetaking related
        # Laravel exclusive
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
}
