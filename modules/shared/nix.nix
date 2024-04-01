{
  pkgs,
  lib,
  user,
  system,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  services = {
    nix-daemon.enable = true;
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Setup user, packages, programs
  nix = {
    # Use this instead of services.nix-daemon.enable if you
    # don't wan't the daemon service to be managed for you.
    # useDaemon = true;

    package = pkgs.nix; # or nix.unStable

    # do garbage collection weekly to keep disk usage low
    gc = {
      # user = "root";
      # interval = {
      #   Weekday = 0;
      #   Hour = 2;
      #   Minute = 0;
      # };
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };

    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # Disable auto-optimise-store because of this issue:
      #   https://github.com/NixOS/nix/issues/7273
      # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
      auto-optimise-store = false;
      # enable flakes globally
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["@admin" "${user}"];
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
