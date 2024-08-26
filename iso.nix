{ config, pkgs, ... }:
{

  # compress 6x faster than default
  # but iso is 15% bigger
  # tradeoff acceptable because we don't want to distribute
  # default is xz which is very slow
  isoImage.squashfsCompression = "zstd -Xcompression-level 6";
  
  # my azerty keyboard
  i18n.defaultLocale = "pt_BR.UTF-8";
  services.xserver.layout = "br";
  console = {
    keyMap = "br-abnt2";
  };
  
  # xanmod kernel for better performance
  # see https://xanmod.org/
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  
  # prevent GPU to stay at 100% performance
  hardware.nvidia.powerManagement.enable = true;
  
  # sound support
  hardware.pulseaudio.enable = true;
 
  # getting IP from dhcp
  # no network manager
  networking.dhcpcd.enable = true;
  networking.hostName = "biggy"; # Define your hostname.
  networking.wireless.enable = false;

  # many programs I use are under a non-free licence
  nixpkgs.config.allowUnfree = true;

  # enable steam
  programs.steam.enable = true;

  # enable ACPI
  services.acpid.enable = true;

  # thermal CPU management
  services.thermald.enable = true;

  # enable XFCE, nvidia driver and autologin
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.timeout = 10;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.xkbOptions = "eurosign:e";

  time.timeZone = "Europe/Paris";

  # declare the gaming user and its fixed password
  users.mutableUsers = false;
  users.users.gaming.initialHashedPassword = "$6$bVayIA6aEVMCIGaX$FYkalbiet783049zEfpugGjZ167XxirQ19vk63t.GSRjzxw74rRi6IcpyEdeSuNTHSxi3q1xsaZkzy6clqBU4b0";
  users.users.gaming = {
    isNormalUser = true;
    # shell = pkgs.fish;
    uid = 1001;
    extraGroups = [ "networkmanager" "video" ];
  };
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "gaming";
  };

  # mount the NFS before login
  systemd.services.mount-gaming = {
    path = with pkgs; [ nfs-utils ];
    serviceConfig.Type = "oneshot";
    script = ''
      mount.nfs -o fsc,nfsvers=4.2,wsize=1048576,rsize=1048576,async,noatime t470-eth.local:/home/jeux/ /home/jeux/
    '';
    before = [ "display-manager.service" ];
    wantedBy = [ "display-manager.service" ];
    after = [ "network-online.target" ];
  };

  # useful packages
  environment.systemPackages = with pkgs; [
    bwm_ng
    chiaki
    dunst # for notify-send required in Dead Cells
    file
    fzf
    kakoune
    libstrangle
    lutris
    mangohud
    minigalaxy
    ncdu
    nfs-utils
    steam
    steam-run
    tmux
    unzip
    vlc
    xorg.libXcursor
    zip
  ];

}
