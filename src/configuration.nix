{ pkgs, ... }:

{
  boot.tmp.useTmpfs = true;

  hardware.bluetooth.enable = true;

  # enable networking
  networking.networkmanager.enable = true;

  # set your time zone
  time.timeZone = "Europe/London";

  # select internationalisation properties
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # configure console keymap
  console.keyMap = "uk";

  # define a user account
  users.users.charles = {
    isNormalUser = true;
    description = "Charles Johnson";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
  };

  # enable automatic login for the user
  services.getty.autologinUser = "charles";

  # start sway automatically
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';

  # list packages installed in system profile
  environment.systemPackages = with pkgs; [
    # app
    audacious
    firefox
    gimp
    pavucontrol

    # cmd app
    git
    helix
    himalaya
    zola

    # security
    libfido2
    solo2-cli
    yubikey-manager

    # cmd util
    bottom
    exa
    fd
    file
    jq
    ripgrep
    unzip
    usbutils
    wget
    zip

    # cmd env
    starship

    # language server
    nil
    rust-analyzer
    typst-lsp

    # language
    gcc
    pkg-config
    (python3.withPackages(ps: with ps; [
      python-lsp-ruff
      pylsp-mypy
      pyftpdlib
      pytest
    ]))
    rustup
    typst
  ];

  services = {
    journald.extraConfig = "Storage=volatile";

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    dbus.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # bonjour
  services.resolved.enable = true;
  networking.networkmanager.connectionConfig."connection.mdns" = 2;
  services.avahi.enable = true;

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        mako
        wofi
        alacritty
        grim
        slurp
        wl-clipboard
      ];
    };
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 365d";
    };
  };

}
