_:
with programs; {
  zsh = {
    enable = true;
    autocd = false;
    cdpath = ["~/.local/share/src"];
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];
    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      if [[ "$(uname)" == "Linux" ]]; then
        alias pbcopy='xclip -selection clipboard'
      fi

      # Define variables for directories
      export PATH=$HOME/.local/share/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Always color ls and group directories
      alias ls='ls --color=auto'
    '';
  };
}
