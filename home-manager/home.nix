# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "tomek";
    homeDirectory = "/home/tomek";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = { 
    enable = true;
    userName = "Tomasz Lutoborski";
    userEmail = "tomasz@lutoborski.net";
  };

  programs.zsh = {
    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "v0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
    ];
    enable = true;
    shellAliases = {
      ll = "ls -l";
    };
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" "sudo" ];
      theme = "robbyrussell";
    };
    initExtra = ''
      alias lt="exa -1T --icons"
    '';
  };



  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      # package.disabled = true;
    };
  };

  programs.nixvim = {
    colorschemes.gruvbox.enable = true;
  };

  gtk = {
    enable = true;

    theme = {
      name = "gruvbox";
      package = pkgs.gruvbox-gtk-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "blur-my-shell@aunetx"
      ];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    lazygit
    nnn 
    zip
    unzip
    ripgrep
    fzf
    tree
    which
    btop
    gh
    zoxide
    bat
    nodejs
    thefuck
    wl-clipboard
    gnomeExtensions.user-themes
    gnomeExtensions.blur-my-shell
    gnomeExtensions.unite
    gruvbox-gtk-theme
    bibata-cursors
    exa
    tldr
    rustup
    cabal-install
    megasync
    ffmpeg
    fd
    spotify
    discord
    slack
    logseq
    pixelorama
    inkscape
    blender
  ];
}
