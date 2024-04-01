{...}: {
  imports = [
    ./system.nix
    # ./packages.nix
    # TODO Move to user setup, not system
    ./fonts.nix
    ./nix-homebrew.nix
    ./home-manager.nix
  ];

  # Load configuration that is shared across systems
  # environment.systemPackages = with pkgs; [
  #   agenix.packages."${pkgs.system}".default
  # ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });
}
