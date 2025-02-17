# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

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
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };
  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk23;
  };

  services.flatpak.enable = true;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];  
  # services.emacs = {
  #   enable = true;
  #   package = pkgs.emacs29-pgtk;
  #   startWithGraphical = true;
  #   defaultEditor = true;
  # };
  # Enable the X11 windowing system.

  # Enable the GNOME Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;

    videoDrivers = [ "nvidia" ];
  };

  services.syncthing = {
    user = "tomek";
    overrideDevices = true;
    overrideFolders = true;
    dataDir = "/home/tomek/Documents";
    configDir = "/home/tomek/.local/state/syncthing";
    enable = true;
    openDefaultPorts = true;
    settings = {
      devices = {
        "MI9" = { id = "APQONYI-XY5B5RB-YK6LXUE-URWYMEB-7LZZ2HR-U6TTMYV-EBYTVT7-BZO7CAG"; };
      };
      folders = {
        "Camera" = {
          path = "/home/tomek/Pictures/phone";
          id = "x98na-echpk";
          devices = [ "MI9" ];
          versioning.type = "trashcan";
        };
        "LogSeq" = {
          path = "/home/tomek/Documents/notes";
          id = "cwkzd-k9qq2";
          devices = [ "MI9" ];
          versioning.type = "trashcan";
        };
        "Sync" = {
          path = "/home/tomek/Sync";
          id = "5gx1s-ud21e";
          devices = [ "MI9" ];
          versioning.type = "trashcan";
        };
      };
    };
  };

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
    };
  };

  programs.virt-manager.enable = true;

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  services.postgresql = {
    package = pkgs.postgresql_16;
    enable = true;
    ensureDatabases = [ "tomek" ];
    ensureUsers = [
      {
        name = "tomek";
        ensureDBOwnership = true;
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local  all             all                                     trust
      host   all             all             127.0.0.1/32            md5
    '';
  };


  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
      # hardware.nvidia = {
      #   prime.offload.enable = lib.mkForce false;
      #   powerManagement.enable = lib.mkForce false;
      # };
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware = {
    pulseaudio.enable = false;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # opengl.enable = true;

    nvidia = {
      prime = {
        sync.enable = true;

        # Make sure to use the correct Bus ID values for your system!
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:5:0:0";
      };
      # Modesetting is needed for most Wayland compositors
      modesetting.enable = true;

      powerManagement = {
        enable = true;
      };

      # Use the open source version of the kernel module
      # Only available on driver 515.43.04+
      open = true;

      # Enable the nvidia settings menu
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  users.extraGroups.vboxusers.members = [ "tomek" ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tomek = {
    isNormalUser = true;
    description = "tomek";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" "adbusers" "libvirtd" "kvm" ];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.zsh;
  };

  nix.settings = {
    experimental-features = [ "flakes" "nix-command" ];
    trusted-users = [ "tomek" "root" ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cache.iog.io"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    pciutils
    gnat13
    zsh
    cudaPackages.cudatoolkit
    qemu
    devenv
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term-slab
    nerd-fonts.cousine
    nerd-fonts.droid-sans-mono
    rubik
    open-sans
    roboto
    merriweather
  ];

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=30
  '';

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit # text editor
    gnome-text-editor
    geary
    cheese # webcam tool
    gnome-terminal
    epiphany # web browser
    evince
    totem # video player
    simple-scan
    gnome-music
    gnome-contacts
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    gnome-weather
    gnome-maps
  ]);

  # some programs need suid wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
