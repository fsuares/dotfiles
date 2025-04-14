{ config, pkgs, ... }:

{
  # User information
  home.username = "ducck";
  home.homeDirectory = "/home/ducck";

  # =======================
  # 🎨 GTK Theme & Cursor
  # =======================
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "elementary"; # Pantheon/Elementary icons
      package = pkgs.pantheon.elementary-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      size = 16;
      package = pkgs.bibata-cursors;
    };
  };

  # Cursor settings for non-GTK apps
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 16;
  };

  # ===========================================
  # 🧼 Hide system-wide .desktop duplicates
  # ===========================================
  xdg.configFile."applications/nomacs.desktop".text = ''
    [Desktop Entry]
    NoDisplay=true
  '';

  xdg.configFile."applications/amberol.desktop".text = ''
    [Desktop Entry]
    NoDisplay=true
  '';

  # ===========================================
  # 🧩 Custom .desktop entries for Wofi/Rofi
  # ===========================================
  xdg.desktopEntries = {
    mpv = {
      name = "MPV Media Player";
      genericName = "Media Player";
      exec = "mpv %U";
      icon = "media-video"; # elementary icon
      type = "Application";
      categories = [ "AudioVideo" "Player" "Video" ];
    };

    nomacs = {
      name = "Nomacs";
      genericName = "Image Viewer";
      exec = "nomacs %F";
      icon = "image"; # elementary icon
      type = "Application";
      categories = [ "Graphics" "Viewer" ];
    };

    amberol = {
      name = "Amberol";
      genericName = "Music Player";
      exec = "amberol";
      icon = "multimedia-player"; # elementary icon
      type = "Application";
      categories = [ "AudioVideo" "Player" "Audio" ];
    };
  };

  # ===================================
  # 🎨 Qt5/Qt6 appearance with qt5ct
  # ===================================
  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=Adwaita-Dark
    icon_theme=elementary
    font="JetBrains Nerd Font,10,-1,5,50,0,0,0,0,0"
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=Adwaita-Dark
    icon_theme=elementary
    font="JetBrains Nerd Font,10,-1,5,50,0,0,0,0,0"
  '';

  # ========================
  # 📦 User-level packages
  # ========================
  home.packages = with pkgs; [
    # Qt theming tools
    libsForQt5.qt5ct
    qt6ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum

    # Icon and theme packages
    pantheon.elementary-icon-theme
    bibata-cursors
    adwaita-icon-theme
    adwaita-qt
    hicolor-icon-theme
  ];

  # ===========================
  # 🌍 Session environment vars
  # ===========================
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "Adwaita-Dark";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "16";
    XDG_DATA_DIRS = "${pkgs.pantheon.elementary-icon-theme}/share:${pkgs.hicolor-icon-theme}/share:/usr/share";
  };

  # ==================================
  # 📋 Cliphist clipboard background
  # ==================================
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Cliphist clipboard history daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
      Environment = "WAYLAND_DISPLAY=wayland-1";
    };
    Install.WantedBy = [ "default.target" ];
  };

  # ⏲️ Timer to clean clipboard history every 12h
  systemd.user.timers."cliphist-clear" = {
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "12h";
      Persistent = true;
    };
    Unit = {
      Description = "Clear clipboard history every 12h";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  # One-shot service triggered by the timer above
  systemd.user.services."cliphist-clear" = {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.cliphist}/bin/cliphist wipe";
    };
    Unit = {
      Description = "Execute cliphist wipe";
    };
  };

  # =====================
  # 🐚 Zsh Shell Aliases
  # =====================
  programs.zsh.shellAliases = {
    konsole = "ghostty";
  };

  # ============================
  # 📦 Home Manager version pin
  # ============================
  home.stateVersion = "24.11";
}

