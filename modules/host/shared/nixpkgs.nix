{
  outputs,
  system,
  ...
}: {
  nixpkgs = {
    hostPlatform = system;

    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;

      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      # allowUnfreePredicate = _: true;
      # permittedInsecurePackages = [
      #   "electron-25.9.0"
      # ];
    };

    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };
}
