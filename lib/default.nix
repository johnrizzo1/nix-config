{inputs, ...}: {
  # Helper to create a default shell for each platform with the ability to override.
  # mkDevShells = { packages ? null, shellHook ? null }:
  #   libx.forAllSystems(system:
  #     let
  #       pkgs = nixpkgs.legacyPackages.${system};
  #     in {
  #       default = with pkgs; mkShell {
  #         nativeBuildInputs = with pkgs; [ bashInteractive git age age-plugin-yubikey ];
  #         shellHook = with pkgs; ''
  #           export EDITOR=vim
  #         '';
  #       };
  #     }
  #   );

  # Helper for creating darwin/home-manager systems
  # mkDarwinConfiguration =
  #   { hostname, username ? null }:
  #   inputs.nix-darwin.lib.darwinSystem {
  #     inherit system; #specialArgs;
  #     specialArgs = inputs;
  #     modules = [
  #       # home manager
  #       home-manager.darwinModules.home-manager
  #       {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #         home-manager.extraSpecialArgs = specialArgs;
  #         home-manager.users.${username} = import ./home;
  #       }

  #       # homebrew setup
  #       nix-homebrew.darwinModules.nix-homebrew
  #           {
  #             nix-homebrew = {
  #               inherit user;
  #               enable = true;
  #               taps = {
  #                 "homebrew/homebrew-core" = homebrew-core;
  #                 "homebrew/homebrew-cask" = homebrew-cask;
  #                 "homebrew/homebrew-bundle" = homebrew-bundle;
  #               };
  #               mutableTaps = false;
  #               autoMigrate = true;
  #             };
  #           }
  #     ]
  #   };

  # Helper function for generating host configs
  # mkNixOSHostConfiguration =
  #   { hostname, desktop ? null, pkgsInput ? inputs.unstable }:
  #   pkgsInput.lib.nixosSystem {
  #     specialArgs = { inherit inputs outputs stateVersion username hostname desktop; };
  #     modules = [
  #       inputs.agenix.nixosModules.default
  #       inputs.lanzaboote.nixosModules.lanzaboote
  #       inputs.libations.nixosModules.libations
  #       outputs.nixosModules.scrutiny
  #       ../host
  #     ];
  #   };

  forAllSystems = f:
    inputs.nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ]
    f;
}
