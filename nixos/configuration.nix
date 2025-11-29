{ config, pkgs, lib, ... }:

{
  imports = [
    <nixos-hardware/dell/xps/15-9510>
    <home-manager/nixos>
    ./hardware-configuration.nix
  ];

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  programs.zsh.enable = true;

  users.users.fer = {
    isNormalUser = true;
    description = "Fernando Suares";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "libvirtd" "kvm" ];
    shell = pkgs.zsh;
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.fer = import /home/fer/.config/home-manager/home.nix;

  nixpkgs.config.allowUnfree = true;

  # permitir beekeeper inseguro
  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.1.5"
  ];

  services.displayManager.ly.enable = true;

  console.keyMap = "us";

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
  ];

  programs.dconf.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.flatpak.enable = true;

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "16";
  };

  # ---- FONTS FIX ----
  fonts.packages =
    with pkgs;
    [
      monaspace
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  # --------------------

  environment.systemPackages = with pkgs; [
    hyprland
    hyprpaper
    hyprlock
    hypridle
    hyprshot
    waybar
    wofi
    swaynotificationcenter

    ghostty
    neovim
    wget
    curl
    git
    yazi
    gnupg
    unzip
    nitch
    zsh
    fzf
    eza
    yt-dlp
    wl-clipboard
    cliphist
    trash-cli
    desktop-file-utils

    bluez
    bluez-tools
    blueman

    libsForQt5.dolphin
    nomacs
    amberol
    mpv
    chromium
    spotify
    thunderbird
    vscode
    zed-editor
    beekeeper-studio
    bruno

    docker
    docker-compose
    nodejs
    zig
    bun
    yarn
    pnpm
    go
    rustup
    jdk23
  ];

  services.udisks2.enable = true;
  services.dbus.enable = true;

  hardware.bluetooth.enable = true;
}
