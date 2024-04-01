{pkgs, ...}: {
  imports = [
    ./nix.nix
    ./nixpkgs.nix
  ];

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs;
    [
      vim
      # emacs-unstable
    ]
    ++ (import ./packages.nix {inherit pkgs;});
}
