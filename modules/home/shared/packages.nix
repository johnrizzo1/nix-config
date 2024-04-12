{pkgs, ...}: {
  imports = [];
  home = {
    sessionVariables = {
      #EDITOR = ''nvr -c "set bufhidden=delete" -o'';
      #TERM = "xterm";
    };

    packages = with pkgs; [
      aria2
      curl
      wget
      tree
      xh # curl alternative

      #neovim (set by ./nvim.nix)
      #neovim-remote # I use Neovim-remote to run with :terminal within Neovim (used implicitly by ./git.nix)

      fd # find alternative
      ripgrep
      eza
      entr
      p7zip

      zenith # top alternative
      bat # cat alternative
      jq # JSON processor
      yq-go # yq - YAML processor
      xxd
      hexyl # xxd alternative
      file
      #delta # diff alternative (used implicitly by git.nix)
      dogdns # dog - dig alternative

      openssl

      # Personal data sync
      bitwarden-cli
      syncthing

      # Data handling
      duckdb
      steampipe
      #(python.withPackages (ps: [ps.sling]))

      # Containers and virtualization
      podman
      podman-compose
      qemu

      # Nix stuff
      #cntr # To debug nix builds

      # TODO: Start using those
      navi # CLI cheatsheets
      glow # Markdown highlighting
    ];
  };

  # programs = {
  #   home-manager.enable = true;
  # };
}
