{package_info, ...}: {
  # Load configuration that is shared across systems
  environment.systemPackages = package_info.shared_system_packages;
}
