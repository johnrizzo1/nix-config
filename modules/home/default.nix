{
  lib,
  pkgs,
  ...
}: {
  imports =
    [./shared]
    ++ lib.optional pkgs.stdenv.isDarwin ./darwin;
}
