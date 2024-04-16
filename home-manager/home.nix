# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   koka = final.koka.overrideAttrs
      #     (oldAttrs: rec {
      #       version = "3.0.1";
      #       src = pkgs.fetchFromGitHub
      #         {
      #           owner = "koka-lang";
      #           repo = "koka";
      #           rev = "v${version}";
      #           sha256 = "sha256-fLk4XokoKRQTLlBfpc7JZ3LUiYSIUZTBLyxTsCCXW7Q=";
      #           fetchSubmodules = true;
      #         };
      #     });
      # })

    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [ "electron-25.9.0" "freeimage-unstable-2021-11-01" ];
    };
  };


  home = {
    username = "tomek";
    homeDirectory = "/home/tomek";
    # sessionVariables = {
    #   QT_STYLE_OVERRIDE = "kvantum";
    # };
    sessionPath = [
      "$HOME/.cargo/bin"
    ];
  };

  qt = {
    enable = true;
    # platformTheme = "gnome";
    style.name = "kvantum";
  };

  xdg = {
    configHome = "/home/tomek/.config";
    enable = true;
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
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" "sudo" ];
      theme = "robbyrussell";
    };
    initExtra = ''
      alias lj="eza"
      # shellcheck disable=SC2034,SC2153,SC2086,SC2155

      # Above line is because shellcheck doesn't support zsh, per
      # https://github.com/koalaman/shellcheck/wiki/SC1071, and the ignore: param in
      # ludeeus/action-shellcheck only supports _directories_, not _files_. So
      # instead, we manually add any error the shellcheck step finds in the file to
      # the above line ...

      # Source this in your ~/.zshrc
      autoload -U add-zsh-hook

      zmodload zsh/datetime 2>/dev/null

      # If zsh-autosuggestions is installed, configure it to use Atuin's search. If
      # you'd like to override this, then add your config after the $(atuin init zsh)
      # in your .zshrc
      _zsh_autosuggest_strategy_atuin() {
          suggestion=$(atuin search --cmd-only --limit 1 --search-mode prefix -- "$1")
      }

      if [ -n "''${ZSH_AUTOSUGGEST_STRATEGY:-}" ]; then
          ZSH_AUTOSUGGEST_STRATEGY=("atuin" "''${ZSH_AUTOSUGGEST_STRATEGY[@]}")
      else
          ZSH_AUTOSUGGEST_STRATEGY=("atuin")
      fi

      export ATUIN_SESSION=$(atuin uuid)
      ATUIN_HISTORY_ID=""

      _atuin_preexec() {
          local id
          id=$(atuin history start -- "$1")
          export ATUIN_HISTORY_ID="$id"
          __atuin_preexec_time=''${EPOCHREALTIME-}
      }

      _atuin_precmd() {
          local EXIT="$?" __atuin_precmd_time=''${EPOCHREALTIME-}

          [[ -z "''${ATUIN_HISTORY_ID:-}" ]] && return

          local duration=""
          if [[ -n $__atuin_preexec_time && -n $__atuin_precmd_time ]]; then
              printf -v duration %.0f $(((__atuin_precmd_time - __atuin_preexec_time) * 1000000000))
          fi

          (ATUIN_LOG=error atuin history end --exit $EXIT ''${duration:+--duration=$duration} -- $ATUIN_HISTORY_ID &) >/dev/null 2>&1
          export ATUIN_HISTORY_ID=""
      }

      _atuin_search() {
          emulate -L zsh
          zle -I

          # swap stderr and stdout, so that the tui stuff works
          # TODO: not this
          local output
          # shellcheck disable=SC2048
          output=$(ATUIN_SHELL_ZSH=t ATUIN_LOG=error atuin search $* -i -- $BUFFER 3>&1 1>&2 2>&3)

          zle reset-prompt

          if [[ -n $output ]]; then
              RBUFFER=""
              LBUFFER=$output

              if [[ $LBUFFER == __atuin_accept__:* ]]
              then
                  LBUFFER=''${LBUFFER#__atuin_accept__:}
                  zle accept-line
              fi
          fi
      }
      _atuin_search_vicmd() {
          _atuin_search --keymap-mode=vim-normal
      }
      _atuin_search_viins() {
          _atuin_search --keymap-mode=vim-insert
      }

      _atuin_up_search() {
          # Only trigger if the buffer is a single line
          if [[ ! $BUFFER == *$'\n'* ]]; then
              _atuin_search --shell-up-key-binding "$@"
          else
              zle up-line
          fi
      }
      _atuin_up_search_vicmd() {
          _atuin_up_search --keymap-mode=vim-normal
      }
      _atuin_up_search_viins() {
          _atuin_up_search --keymap-mode=vim-insert
      }

      add-zsh-hook preexec _atuin_preexec
      add-zsh-hook precmd _atuin_precmd

      zle -N atuin-search _atuin_search
      zle -N atuin-search-vicmd _atuin_search_vicmd
      zle -N atuin-search-viins _atuin_search_viins
      zle -N atuin-up-search _atuin_up_search
      zle -N atuin-up-search-vicmd _atuin_up_search_vicmd
      zle -N atuin-up-search-viins _atuin_up_search_viins

      # These are compatibility widget names for "atuin <= 17.2.1" users.
      zle -N _atuin_search_widget _atuin_search
      zle -N _atuin_up_search_widget _atuin_up_search

      bindkey -M emacs '^r' atuin-search
      bindkey -M viins '^r' atuin-search-viins
      bindkey -M vicmd '/' atuin-search
      bindkey -M emacs '^[[A' atuin-up-search
      bindkey -M vicmd '^[[A' atuin-up-search-vicmd
      bindkey -M viins '^[[A' atuin-up-search-viins
      bindkey -M emacs '^[OA' atuin-up-search
      bindkey -M vicmd '^[OA' atuin-up-search-vicmd
      bindkey -M viins '^[OA' atuin-up-search-viins
      bindkey -M vicmd 'k' atuin-up-search-vicmd

      _ng_yargs_completions()
      {
        local reply
        local si=$IFS
        IFS=$'
      ' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" ng --get-yargs-completions "''${words[@]}"))
        IFS=$si
        _describe 'values' reply
      }
      compdef _ng_yargs_completions ng

    '';
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 12;
    };
    keybindings = {
      "ctrl+alt+enter" = "launch --cwd=current";
      "alt+l" = "next_window";
      "alt+h" = "previous_window";
      "alt+k" = "next_tab";
      "alt+j" = "previous_tab";
      "kitty_mod+n" = "new_tab";
      "kitty_mod+m" = "next_layout";
    };
    shellIntegration.enableZshIntegration = true;
    extraConfig = ''
      enabled_layouts grid, stack

      cursor     #c7c7c7
      cursor_text_color #feffff
      selection_foreground #3e3e3e
      selection_background #c1ddff
      foreground #c8c8c8
      background #323232
      color0     #252525
      color8     #555555
      color1     #be7472
      color9     #ff9900
      color2     #709772
      color10    #97bb98
      color3     #989772
      color11    #fefdbc
      color4     #7199bc
      color12    #9fbdde
      color5     #727399
      color13    #989abc
      color6     #719899
      color14    #6fbbbc
      color7     #7f7f7f
      color15    #feffff
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
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

  gtk = {
    enable = true;

    gtk2.extraConfig = "gtk-application-prefer-dark-theme=1";

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

  home.activation.keyboardSettings = lib.hm.dag.entryAfter
    [ "writeBoundary" ]
    ''
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/peripherals/keyboard/delay "uint32 160"
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/peripherals/keyboard/repeat-interval "uint32 6"
    '';

  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "blur-my-shell@aunetx"
      ];

      favorite-apps = [
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "org.mozilla.Thunderbird.desktop"
        "firefox.desktop"
        "org.gnome.Software.desktop"
      ];
    };

    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>w" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      activate-window-menu = [ ];
      switch-to-workspace-down = [ ];
      switch-to-workspace-up = [ ];
    };

    "org/gnome/desktop/interface" = {
      gtk-theme = "Gruvbox-Dark-BL";
      color-scheme = "prefer-dark";
      cursor-theme = "Bibata-Modern-Amber";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      icon-theme = "Papirus-Dark";
    };

    "org/gnome/desktop/notifications/application/spotify" = {
      enable = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
      tap-to-click = true;
      speed = 0.235;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "kitty super";
      command = "kitty";
      binding = "<Super>t";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "firefox";
      command = "firefox";
      binding = "<Super>b";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "emacs";
      command = "emacs";
      binding = "<Super>e";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "spotify";
      command = "spotify";
      binding = "<Super>s";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      name = "vscode";
      command = "code";
      binding = "<Super>c";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "suspend";
    };

    "org/gnome/desktop/session" = {
      idle-delay = 0;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    zip
    unzip
    ripgrep
    fzf
    tree
    which
    btop
    gh
    bat
    dua
    oha
    wl-clipboard
    gnomeExtensions.user-themes
    gnomeExtensions.blur-my-shell
    gruvbox-gtk-theme
    bibata-cursors
    tldr
    ffmpeg
    fd
    vscode-fhs
    nil
    nixpkgs-fmt
    nodePackages.vscode-json-languageserver
    libsForQt5.qtstyleplugin-kvantum
    papirus-icon-theme
    gnome3.gnome-tweaks
    foliate
    libsForQt5.okular
    megasync
    spotify
    nodejs_20
    lshw
    insomnia
    brave
    thefuck
    babashka
    glxinfo
    bun
    flyctl
    du-dust
    atuin
    eza
    hyperfine
    drawio
    tor-browser
    joplin-desktop
    wget
    gnupg
    opentofu
    nix-tree
    vagrant
    # (blender.override {
    #   cudaSupport = true;
    # })
    # pixelorama
    # libreoffice-fresh
    # inkscape-with-extensions
    # krita
    # emacs29
  ];
}

  
