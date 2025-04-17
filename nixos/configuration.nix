{ config, pkgs, ... }:

{
  # ============================
  # 📂 Import Configuration Files
  # ============================
  imports = [
    <nixos-hardware/dell/xps/15-9510>
    <home-manager/nixos>
    ./hardware-configuration.nix
  ];

  # ============================
  # 🌐 Localization & System Info
  # ============================
  networking.hostName = "sourcenix";
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # ============================
  # 🧪 Enable Experimental Features
  # ============================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ============================
  # ⚙️ System State & Bootloader
  # ============================
  system.stateVersion = "24.11";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================
  # 🌐 Network Configuration
  # ============================
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;
  # networking.proxy.default = "http://user:password@proxy:port/";

  # ============================
  # 🔊 Audio Configuration
  # ============================
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # ============================
  # 🖨️ Printing Support
  # ============================
  services.printing.enable = true;

  # ============================
  # 🐚 Shell Configuration
  # ============================
  programs.zsh.enable = true;

  # ============================
  # 👤 User: ducck
  # ============================
  users.users.ducck = {
    isNormalUser = true;
    description = "Fernando Suares";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "libvirtd" "kvm" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # ============================
  # 🏠 Home Manager Integration
  # ============================
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.ducck = import /home/ducck/.config/home-manager/home.nix;

  # ============================
  # 📦 Package Policies
  # ============================
  nixpkgs.config.allowUnfree = true;

  # ============================
  # 👁️ Display Manager
  # ============================
  services.displayManager.ly.enable = true;
  console.keyMap = "us";

  # ============================
  # 🧩 Desktop Integration
  # ============================
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  programs.dconf.enable = true;

  # ============================
  # 🖼️ Hyprland (Wayland)
  # ============================
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ============================
  # 📦 Flatpak Support
  # ============================
  services.flatpak.enable = true;

  # ============================
  # 🖱️ Cursor Configuration
  # ============================
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "16";
  };

  # ============================
  # 🔤 Fonts
  # ============================
  fonts.packages = with pkgs; [
    nerdfonts
    monaspace
  ];

  # ============================
  # 📦 System Packages
  # ============================
  environment.systemPackages = with pkgs; [
    # Hyprland ecosystem
    hyprland  # Hyprland Wayland compositor
    hyprpaper  # Wallpaper manager for Hyprland
    hyprlock  # Screen locker for Hyprland
    hypridle  # Idle manager for Hyprland
    hyprshot  # Screenshot tool for Hyprland
    waybar  # Status bar for Wayland environments
    wofi  # Application launcher for Wayland
    swaynotificationcenter  # Notification center compatible with Wayland
    ly  # Lightweight terminal-based display manager
    home-manager  # Manage user-specific configuration declaratively

    # CLI tools
    konsole  # KDE terminal emulator
    ghostty  # Minimal, fast GPU-accelerated terminal
    neovim  # Modern Vim-based text editor
    wget  # Download files from the web via terminal
    curl  # Transfer data from or to a server
    git  # Distributed version control system
    yazi  # Terminal file manager written in Rust
    gnupg  # GPG encryption and signing tool
    gnutar  # Tar utility for archive management
    gnumake  # Automation tool for building projects
    unzip  # Extract ZIP archive files
    glibc  # GNU C standard library (base dependency)
    coreutils  # GNU basic file, shell, and text utilities
    nitch  # Lightweight system info tool for the terminal
    zsh  # Z Shell, an extended Bourne shell with improvements
    networkmanager  # Network configuration and management tool
    cl  # Command-line tool (your custom or preferred utility)
    gawk  # Pattern scanning and text processing language
    pamixer  # CLI tool for volume control via PulseAudio
    wl-clipboard  # Clipboard manager for Wayland
    cliphist  # Clipboard history manager for Wayland
    fzf  # Fuzzy finder for the command line
    vimPlugins.fzfWrapper  # FZF integration for Neovim
    trash-cli  # Move files to trash via command line
    eza  # Modern replacement for 'ls'
    yt-dlp  # YouTube and video downloader
    desktop-file-utils  # Utilities to manage .desktop entries
    bluez
    bluez-tools
    blueman

    # GUI apps
    dolphin  # KDE file manager
    nomacs  # Lightweight image viewer
    amberol  # Minimalist music player for GNOME
    mpv  # Versatile media player
    chromium  # Open-source web browser by Google
    spotify  # Spotify desktop client
    thunderbird  # Mozilla email client
    vscode  # Visual Studio Code editor
    zed-editor  # Fast, modern code editor
    beekeeper-studio  # GUI database manager
    bruno  # REST API client (similar to Postman)

    # Dev tools
    docker  # Containerization platform
    docker-compose  # Define and run multi-container Docker apps
    nodejs_23  # JavaScript runtime environment
    zig  # Low-level programming language focused on performance
    bun  # Fast JavaScript runtime and bundler
    yarn  # JavaScript package manager (alternative to npm)
    pnpm  # Fast, disk-efficient package manager
    go  # Programming language by Google
    rustup  # Rust toolchain installer
    jdk23  # Java Development Kit (version 23)
  ];

  services.udisks2.enable = true;
  services.dbus.enable = true;

  # ============================
  # 🧪 Optional Features
  # ============================
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # ============================
  # Bluetooth Configuration
  # ============================
  hardware.bluetooth.enable = true;

}

