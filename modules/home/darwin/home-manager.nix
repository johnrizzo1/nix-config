{
  config,
  home-manager,
  user,
  name,
  email,
  stateVersion,
  pkgs,
  ...
}: {
  imports = [
    ./dock
    home-manager.darwinModules.home-manager
  ];

  home-manager = {
    enable = true;
    useGlobalPkgs = true;
    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      home = {
        inherit stateVersion;
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
      };

      programs = {} // import ../shared/home-manager.nix {inherit config pkgs lib user name email;};

      manual.manpages.enable = true;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local = {
    dock.enable = true;
    dock.entries = [
      {path = "/Applications/Slack.app/";}
      {path = "/Applications/Google Chrome.app/";}
      {path = "/Applications/Visual Studio Code.app/";}
      {path = "${pkgs.alacritty}/Applications/Alacritty.app/";}
      {path = "/System/Applications/Music.app/";}
      {
        path = "${config.users.users.${user}.home}/.local/share/";
        section = "others";
        options = "--sort name --view grid --display folder";
      }
      {
        path = "${config.users.users.${user}.home}/.local/share/downloads";
        section = "others";
        options = "--sort name --view grid --display stack";
      }
    ];
  };
}
