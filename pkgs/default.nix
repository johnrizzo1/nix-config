{pkgs ? (import ../nixpkgs.nix) {}}: {
  nixfmt = pkgs.callPackage ./nixfmt.nix {};
}
