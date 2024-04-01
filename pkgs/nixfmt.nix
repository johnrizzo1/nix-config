{pkgs, ...}:
pkgs.writeShellApplication {
  name = "nixfmt";

  # nixpkgs-fmt
  runtimeInputs = with pkgs; [
    deadnix
    statix
    alejandra
  ];

  # nixpkgs-fmt .
  text = ''
    set -x
    deadnix --edit
    statix fix
    alejandra -q .
  '';
}
