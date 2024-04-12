{
  user,
  # nix,
  ...
}: {
  # users.users."jrizzo46" = {
  #   home = "/Users/${user}";
  #   description = ${user};
  # };

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  # nix.settings.trusted-users = [user.user];
}
