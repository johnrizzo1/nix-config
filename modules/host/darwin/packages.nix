# The following packages are shared accross all darwin packages
{package_info, ...}: {
  environment.systemPackages = package_info.shared_system_packages_darwin;

  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = package_info.mas_packages;

    # `brew install`
    brews = package_info.brew_packages;

    # `brew install --cask`
    casks = package_info.cask_packages;
  };
}
