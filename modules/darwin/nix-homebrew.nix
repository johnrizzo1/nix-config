{
  pkgs,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  user,
  ...
}: {
  # TODO user needs to be generalized some how.  Perhaps this doesn't go in the host setup at all.
  imports = [
    nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        inherit user;
        enable = true; # Install Homebrew under the default prefix
        enableRosetta = true;
        taps = {
          "homebrew/homebrew-core" = homebrew-core;
          "homebrew/homebrew-cask" = homebrew-cask;
          "homebrew/homebrew-bundle" = homebrew-bundle;
        };
        mutableTaps = false;
        autoMigrate = true;
      };
    }
  ];

  homebrew = {
    # This is a module from nix-darwin
    # Homebrew is *installed* via the flake input nix-homebrew
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    masApps = {
      # "1password" = 1333542190;
      # "canva" = 897446215;
      # "drafts" = 1435957248;
      # "hidden-bar" = 1452453066;
      # "wireguard" = 1451685025;
      # "yoink" = 457622435;
    };
  };
}
