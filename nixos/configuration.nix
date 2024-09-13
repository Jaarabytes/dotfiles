{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # System Configuration
  system.stateVersion = "24.05";
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # Uncomment to enable wireless support via wpa_supplicant
    # wireless.enable = true;
  };

  # Time and Localization
  time.timeZone = "Africa/Nairobi";
  i18n.defaultLocale = "en_US.UTF-8";

  # Desktop Environment
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    libinput.enable = false;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Window Managers
  programs = {
    hyprland.enable = true;
    waybar.enable = true;
  };

  # Audio
  # Disable PulseAudio
  hardware.pulseaudio.enable = false;
  # Enable PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # User Configuration
  users.users.trafalgar = {
    isNormalUser = true;
    description = "Soviet Panda";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "video" ];
    packages = with pkgs; [
      # CLI utilities
      bat fzf ripgrep mlocate eza zip unzip ffmpeg htop btop killall
      # Development tools
      gcc zig go rustc cargo
    ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    # System tools
    wget git tree docker
    # Browsers
    firefox google-chrome chromium brave
    # Communication
    discord telegram-desktop protonvpn-gui riseup-vpn
    # Development
    nodejs python3 python3Packages.pip nodePackages.pyright lazygit vim neovim lazydocker bun deno jre8 vagrant ruby mysql84 pnpm ollama
    # Python and machine learning libraries
    (python3.withPackages (ps: with ps; [ numpy pandas matplotlib scipy scikit-learn torch]))
    # Desktop environment tools
    hyprland wl-clipboard waybar swaybg foot grim swaylock maim kitty
    # Multimedia
    audacious vlc
    # System information
    fastfetch neofetch
    # Additional useful tools
    tmux jq curl gnumake cmake
    # Text editors
    vscodium
    # Version control
    git-lfs
    # File managers
    ranger libsForQt5.dolphin xfce.thunar xfce.thunar-volman
    # Image manipulation
    gimp inkscape
    # Office suite
    libreoffice
    # Password manager
    keepassxc
    # System monitoring
    glances iotop
    # Network tools
    wireshark nmap
    # Virtualization
    virtualbox
  ];

  # Program Configurations
  programs = {
    neovim.enable = true;
    chromium.enable = true;
    git.enable = true;
    tmux.enable = true;
    zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };
  };

  # Environment Variables
  environment.sessionVariables = {
    NODE_PATH = "${pkgs.nodejs}/lib/node_modules";
    PYTHONPATH = "${pkgs.python3}/lib/python3.10/site-packages";
    GOPATH = "$HOME/go";
    RUST_SRC_PATH = "${pkgs.rustc}/lib/rustlib/src/rust/src";
    EDITOR = "nvim";
  };

  # Services
  services = {
    openssh.enable = true;
    flatpak.enable = true;
    # Enable if you want to use Docker
    docker.enable = true;
    services.gvfs.enable = true;
    services.tumbler.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # Security
  security.sudo.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Firewall configuration (adjust as needed)
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  # Virtualization support
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "trafalgar" ];

  # Optional: Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
