{
  pkgs,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  user,
  ...
}: {
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

  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    # Homebrew is *installed* via the flake input nix-homebrew
    enable = true;

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = package_info.mas_packages;

    # `brew install`
    brews = package_info.brew_packages;

    # `brew install --cask`
    casks = package_info.cask_packages;
  };

  # homebrew = {
  #   # This is a module from nix-darwin
  #   # Homebrew is *installed* via the flake input nix-homebrew
  #   enable = true;
  #   casks = pkgs.callPackage ./casks.nix {};

  #   # These app IDs are from using the mas CLI app
  #   # mas = mac app store
  #   # https://github.com/mas-cli/mas
  #   #
  #   # $ nix shell nixpkgs#mas
  #   # $ mas search <app name>
  #   #
  #   masApps = {
  #     # "1password" = 1333542190;
  #     # "canva" = 897446215;
  #     # "drafts" = 1435957248;
  #     # "hidden-bar" = 1452453066;
  #     # "wireguard" = 1451685025;
  #     # "yoink" = 457622435;
  #   };
  # };
}
