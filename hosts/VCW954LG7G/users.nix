{
  user,
  pkgs,
  # lib,
  # home-manager,
  ...
}: {
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  # Packages to Add
  # gimp
  # darktable

  # pkgs = lib.lists.remove "slack" pkgs; # home-manager.users.${user}.home.packages;
}
