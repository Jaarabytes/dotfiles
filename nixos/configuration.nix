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

  # Desktop Environment and Window Managers
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;  # Enable LightDM
      defaultSession = "none+i3";  # Set i3 as the default session
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
    };
    desktopManager.gnome.enable = true;  # Keep GNOME as an option
    libinput.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Keep other window managers
  programs = {
    hyprland.enable = true;
    waybar.enable = true;
  };

  # Audio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # User Configuration
  users.users.trafalgar = {
    isNormalUser = true;
    description = "Soviet Panda";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "video" ];
    packages = with pkgs; [
      bat fzf ripgrep mlocate eza zip unzip ffmpeg htop btop killall
      gcc zig go rustc cargo
    ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    # Existing packages...
    wget git tree docker
    firefox google-chrome chromium brave
    discord telegram-desktop protonvpn-gui riseup-vpn
    nodejs nodePackages.pyright lazygit vim neovim lazydocker bun deno jre8 vagrant ruby mysql84 pnpm ollama
    (python311.withPackages (ps: with ps; [
                requests
                numpy
                pandas
                pillow
                pip
                pyarrow
		matplotlib
		scipy
		scikit-learn
		torch
		beautifulsoup4
            ]))
    pyright docker-compose sqlitebrowser rabbitmq-c poetry
    hyprland wl-clipboard waybar swaybg foot grim swaylock maim kitty
    audacious vlc simplescreenrecorder
    fastfetch neofetch
    tmux jq curl gnumake cmake
    vscodium
    git-lfs ansible yazi wezterm alacritty kitty sqlite burpsuite gwenview okular
    ranger libsForQt5.dolphin xfce.thunar xfce.thunar-volman
    gimp inkscape
    libreoffice
    keepassxc picom
    glances iotop
    wireshark nmap
    virtualbox
    i3 i3status i3lock dmenu rofi feh dunst
  ];


  # Program Configurations
  programs = {
    neovim.enable = true;
    git.enable = true;
    git.lfs.enable = true;
    git.config = {
        user.name = "jaarabytes";
        user.email = "xavierandole78@gmail.com";
   };
   chromium.enable = true;
   tmux = {
        enable = true;
        plugins = with pkgs.tmuxPlugins; [
            sensible
            vim-tmux-navigator
            yank
        ];
        terminal = "screen-256color";
        extraConfig = ''
        # Set the default shell to zsh
	set-option -g default-shell /run/current-system/sw/bin/zsh

	# Use Ctrl+Space as the prefix key instead of Ctrl+b
	unbind C-b
	set-option -g prefix C-Space
	bind-key C-Space send-prefix

	# Start window numbering at 1
	set -g base-index 1

	# Set easier window split keys (remove duplicate key bindings)
	bind-key v split-window -h
	bind-key h split-window -v

	# Use Alt-arrow keys to switch panes
	bind -n M-Left select-pane -L
	bind -n M-Right select-pane -R
	bind -n M-Up select-pane -U
	bind -n M-Down select-pane -D

	# Use Shift-arrow keys to switch windows
	bind -n S-Left previous-window
	bind -n S-Right next-window

	# Enable mouse mode
	setw -g mouse on

	# Easy config reload
	bind-key r source-file ~/.tmux.conf \; display-message "tmux.conf reloaded."

	# Set the default terminal mode to 256color
	set -g default-terminal "screen-256color"

	# Enable vi mode keys
	setw -g mode-keys vi

	# Increase scrollback buffer size
	set -g history-limit 10000

	# Set status bar appearance
	set -g status-bg black
	set -g status-fg white
	set -g status-left ""
	set -g status-right "#[fg=green]#H"
        '';
   };
   zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };
  };

  # Environment Variables
  environment.sessionVariables = {
    NODE_PATH = "${pkgs.nodejs}/lib/node_modules";
    # PYTHONPATH = "${pkgs.python3}/lib/python3.11/site-packages";
    GOPATH = "$HOME/go";
    RUST_SRC_PATH = "${pkgs.rustc}/lib/rustlib/src/rust/src";
    EDITOR = "nvim";
  };

  # Services
  services = {
   gnome.gnome-keyring.enable = true;
   openssh.enable = true;
   ollama.enable = true;
   mysql.enable = true;
   mysql.package = pkgs.mysql;
   flatpak.enable = true;
   gvfs.enable = true;
   tumbler.enable = true;
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
  #networking.firewall = {
  #  enable = true;
  #  allowedTCPPorts = [ 80 443 3000 5173 8000 8080];
  #};

  # Virtualization support
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "trafalgar" ];
  virtualisation.docker.enable = true;

  # Optional: Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
