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
    sessionVariables = {
      QT_STYLE_OVERRIDE = "kvantum";
    };
    sessionPath = [
      "$HOME/.local/share/coursier/bin"
      "$HOME/.cargo/bin"
    ];
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

  programs.helix = {
    enable = true;
    settings = {
      theme = "base16";
    };
    themes = 
      {
        base16 = let
          bg0 = "#282828";
          bg1 = "#32302f";
          bg2 = "#32302f";
          bg3 = "#45403d";
          bg4 = "#45403d";
          bg5 = "#5a524c";
          bg_statusline1 = "#32302f";
          bg_statusline2 = "#3a3735";
          bg_statusline3 = "#504945";
          bg_diff_green = "#34381b";
          bg_visual_green = "#3b4439";
          bg_diff_red = "#402120";
          bg_visual_red = "#4c3432";
          bg_diff_blue = "#0e363e";
          bg_visual_blue = "#374141";
          bg_visual_yellow = "#4f422e";
          bg_current_word = "#3c3836";

          fg0 = "#d4be98";
          fg1 = "#ddc7a1";
          red = "#ea6962";
          orange = "#e78a4e";
          yellow = "#d8a657";
          green = "#a9b665";
          aqua = "#89b482";
          blue = "#7daea3";
          purple = "#d3869b";
          bg_red = "#ea6962";
          bg_green = "#a9b665";
          bg_yellow = "#d8a657";

          grey0 = "#7c6f64";
          grey1 = "#928374";
          grey2 = "#a89984";
        in {
          "type" = yellow;
          "constant" = purple;
          "constant.numeric" = purple;
          "constant.character.escape" = orange;
          "string" = green;
          "string.regexp" = blue;
          "comment" = grey0;
          "variable" = fg0;
          "variable.builtin" = blue;
          "variable.parameter" = fg0;
          "variable.other.member" = fg0;
          "label" = aqua;
          "punctuation" = grey2;
          "punctuation.delimiter" = grey2;
          "punctuation.bracket" = fg0;
          "keyword" = red;
          "keyword.directive" = aqua;
          "operator" = orange;
          "function" = green;
          "function.builtin" = blue;
          "function.macro" = aqua;
          "tag" = yellow;
          "namespace" = aqua;
          "attribute" = aqua;
          "constructor" = yellow;
          "module" = blue;
          "special" = orange;

          "markup.heading.marker" = grey2;
          "markup.heading.1" = { fg = red; modifiers = ["bold"]; };
          "markup.heading.2" = { fg = orange; modifiers = ["bold"]; };
          "markup.heading.3" = { fg = yellow; modifiers = ["bold"]; };
          "markup.heading.4" = { fg = green; modifiers = ["bold"]; };
          "markup.heading.5" = { fg = blue; modifiers = ["bold"]; };
          "markup.heading.6" = { fg = fg0; modifiers = ["bold"]; };
          "markup.list" = red;
          "markup.bold" = { modifiers = ["bold"]; };
          "markup.italic" = { modifiers = ["italic"]; };
          "markup.link.url" = { fg = blue; modifiers = ["underlined"]; };
          "markup.link.text" = purple;
          "markup.quote" = grey2;
          "markup.raw" = green;

          "diff.plus" = green;
          "diff.delta" = orange;
          "diff.minus" = red;

          "ui.background" = { bg = bg0; };
          "ui.background.separator" = grey0;
          "ui.cursor" = { fg = bg0; bg = fg0; };
          "ui.cursor.match" = { fg = orange; bg = bg_visual_yellow; };
          "ui.cursor.insert" = { fg = bg0; bg = grey2; };
          "ui.cursor.select" = { fg = bg0; bg = blue; };
          "ui.cursorline.primary" = { bg = bg1; };
          "ui.cursorline.secondary" = { bg = bg1; };
          "ui.selection" = { bg = bg3; };
          "ui.linenr" = grey0;
          "ui.linenr.selected" = fg0;
          "ui.statusline" = { fg = fg0; bg = bg3; };
          "ui.statusline.inactive" = { fg = grey0; bg = bg1; };
          "ui.statusline.normal" = { fg = bg0; bg = fg0; modifiers = ["bold"]; };
          "ui.statusline.insert" = { fg = bg0; bg = yellow; modifiers = ["bold"]; };
          "ui.statusline.select" = { fg = bg0; bg = blue; modifiers = ["bold"]; };
          "ui.bufferline" = { fg = grey0; bg = bg1; };
          "ui.bufferline.active" = { fg = fg0; bg = bg3; modifiers = ["bold"]; };
          "ui.popup" = { fg = grey2; bg = bg2; };
          "ui.window" = { fg = grey0; bg = bg0; };
          "ui.help" = { fg = fg0; bg = bg2; };
          "ui.text" = fg0;
          "ui.text.focus" = fg0;
          "ui.menu" = { fg = fg0; bg = bg3; };
          "ui.menu.selected" = { fg = bg0; bg = blue; modifiers = ["bold"];  };
          "ui.virtual.whitespace" = { fg = bg4; };
          "ui.virtual.indent-guide" = { fg = bg4; };
          "ui.virtual.ruler" = { bg = bg3; };

          "hint" = "blue";
          "info" = "aqua";
          "warning" = "yellow";
          "error" = "red";
          "diagnostic" = { modifiers = [ "underlined" ]; };
        };
      };
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

  home.activation.keyboardSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
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
      close = ["<Super>w"];
      move-to-workspace-1 = ["<Shift><Super>1"];
      move-to-workspace-2 = ["<Shift><Super>2"];
      move-to-workspace-3 = ["<Shift><Super>3"];
      move-to-workspace-4 = ["<Shift><Super>4"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"] ;
      activate-window-menu = [];
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
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    lazygit
    zip
    unzip
    ripgrep
    fzf
    tree
    which
    btop
    gh
    bat
    thefuck
    wl-clipboard
    gnomeExtensions.user-themes
    gnomeExtensions.blur-my-shell
    gruvbox-gtk-theme
    bibata-cursors
    tldr
    ffmpeg
    fd
    vscode-fhs
    emacs29
    dconf2nix
    nil
    elixir-ls
    elixir_1_15
    clojure
    clojure-lsp
    haskell-language-server
    jdk17
    nodePackages.vscode-json-languageserver
    libsForQt5.qtstyleplugin-kvantum
    coursier
    papirus-icon-theme
    gnome3.gnome-tweaks
    elan
    foliate
    libsForQt5.okular
    libsForQt5.dolphin
    megasync
    spotify
    nodejs_20
    stack
  ];
}
