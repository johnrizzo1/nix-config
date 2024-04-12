{
  inputs,
  outputs,
  ...
}: {
  # Helper to iterate over each of the system types and call a supplied function.
  # "x86_64-darwin"
  # "aarch64-linux"
  # "i686-linux"
  # "x86_64-linux"
  forAllSystems = f:
    inputs.nixpkgs.lib.genAttrs [
      "aarch64-darwin"
    ]
    f;

  # Helper to create a nix-darwin configuration
  mkDarwinConfiguration = {
    pkgs,
    hostname,
    system ? "aarch64-darwin",
    package_info ? ({
          mas_packages = {
            Xcode = 497799835;
          };
          brew_packages = [
            "curl"
          ];
          cask_packages = [
            "firefox"
            "google-chrome"
            "visual-studio-code"
          ];
          shared_system_packages = with pkgs; [
            killall
            openssh
            wget
            tmux
            vim
            direnv
            zsh
          ];
          shared_system_packages_darwin = with pkgs; [
            dockutil
            mas
            git
            neovim
          ];
        }),
    modulesDir,
    timezone ? null,
  }:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs outputs system pkgs hostname package_info timezone modulesDir;
      };

      modules = [../hosts];
    };

  # Helper to create a home-manager configuration
  # mkHomeConfiguration = {
  #   hostname,
  #   user,
  #   desktop ? ( if inputs.nixpkgs.stdenv.isDarwin
  #               then "macos"
  #               else null),
  # }: inputs.home-manager.lib.homeManagerConfiguration {
  #     extraSpecialArgs = {
  #       inherit inputs outputs stateVersion hostname user desktop;
  #     };
  #     modules = [
  #       ../modules/home
  #     ];
  #   };

  # Helper to setup a nixos host
  # mkNixOSConfiguration = {
  #   hostname,
  #   system,
  #   desktop ? null,
  #   isVM ? false,
  # }:
  #   inputs.nixpkgs.lib.nixosSystem {
  #     extraSpecialArgs = {
  #       inherit inputs outputs hostname desktop isVM;
  #     };

  #     modules = [
  #       ../hosts
  #     ];

  #     # Copy the NixOS configuration file and link it from the resulting system
  #     # (/run/current-system/configuration.nix). This is useful in case you
  #     # accidentally delete configuration.nix.
  #     system.copySystemConfiguration = true;
  #     system.stateVersion = stateVersion;
  #   };
}
