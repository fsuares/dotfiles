{ config, pkgs, ... }:

{
  home.username = "fer";
  home.homeDirectory = "/home/fer";

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "elementary";
      package = pkgs.pantheon.elementary-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      size = 16;
      package = pkgs.bibata-cursors;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    size = 16;
    package = pkgs.bibata-cursors;
  };

  xdg.configFile."applications/nomacs.desktop".text = ''
    [Desktop Entry]
    NoDisplay=true
  '';

  xdg.configFile."applications/amberol.desktop".text = ''
    [Desktop Entry]
    NoDisplay=true
  '';

  xdg.desktopEntries = {
    mpv = {
      name = "MPV Media Player";
      genericName = "Media Player";
      exec = "mpv %U";
      icon = "media-video";
      type = "Application";
      categories = [ "AudioVideo" "Player" "Video" ];
    };

    nomacs = {
      name = "Nomacs";
      genericName = "Image Viewer";
      exec = "nomacs %F";
      icon = "image";
      type = "Application";
      categories = [ "Graphics" "Viewer" ];
    };

    amberol = {
      name = "Amberol";
      genericName = "Music Player";
      exec = "amberol";
      icon = "multimedia-player";
      type = "Application";
      categories = [ "AudioVideo" "Player" "Audio" ];
    };

    virt-manager = {
      name = "Virt-Manager";
      exec = "virt-manager";
      terminal = false;
      icon = "virt-manager";
      type = "Application";
    };
  };

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=Adwaita-Dark
    icon_theme=elementary
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=Adwaita-Dark
    icon_theme=elementary
  '';

  home.packages = with pkgs; [
    libsForQt5.qt5ct
    qt6ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    pantheon.elementary-icon-theme
    bibata-cursors
    adwaita-icon-theme
    adwaita-qt
    hicolor-icon-theme
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "Adwaita-Dark";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "16";
  };

  systemd.user.services.cliphist = {
    Unit = {
      Description = "Cliphist clipboard history daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.timers."cliphist-clear" = {
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "12h";
      Persistent = true;
    };
    Unit.Description = "Clear clipboard history every 12h";
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services."cliphist-clear" = {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.cliphist}/bin/cliphist wipe";
    };
    Unit.Description = "Execute cliphist wipe";
  };

  programs.zsh.shellAliases = {
    konsole = "ghostty";
  };

  home.stateVersion = "24.11";
}
