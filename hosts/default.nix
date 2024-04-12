{
  modulesDir,
  lib,
  pkgs,
  hostname,
  ...
}: {
  imports =
    [
      "${modulesDir}/host/shared/nix.nix"
      "${modulesDir}/host/shared/nixpkgs.nix"
      "${modulesDir}/host/shared/packages.nix"
    ]
    ++ lib.optional pkgs.stdenv.isDarwin
      "${modulesDir}/host/darwin/system.nix"
    ++ lib.optional pkgs.stdenv.isDarwin
      "${modulesDir}/host/darwin/networking.nix"
    ++ lib.optional pkgs.stdenv.isDarwin
      "${modulesDir}/host/darwin/homebrew.nix"
    ++ lib.optional pkgs.stdenv.isDarwin
      "${modulesDir}/host/darwin/packages.nix"
    ++ lib.optional (lib.pathExists ./${hostname}) ./${hostname};
}
