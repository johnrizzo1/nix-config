# The following packages are shared accross all darwin systems
{pkgs, package_info, ...}: {
  environment.systemPackages = 
    package_info.shared_system_packages_darwin;
}
