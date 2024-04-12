{
  description = "multi-user, multi-host nix configuration";

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = rec {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    # "github:nixos/nixpkgs/nixos-23.11";
    # "github:nixos/nixpkgs/nixos-unstable";
    # "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    # fh.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    # home-manager, used for managing user configuration
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    # The `follows` keyword in inputs is used for inheritance.
    # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs`
    # of the current flake, to avoid problems caused by different versions of nixpkgs
    # dependencies.
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    inherit (self) outputs;
    stateVersion = "23.11";
    modulesDir = ./modules;
    libx = import ./lib {inherit (self) inputs outputs modulesDir stateVersion;};
  in rec {
    # This needs to be defined for classical nix commands to work
    packages = libx.forAllSystems (
      system:
        import ./pkgs {
          pkgs = nixpkgs.legacyPackages.${system};
        }
    );

    # A Dev Shell that matches our base packages
    # nix develop
    devShells = libx.forAllSystems (
      system:
        import ./shell.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        }
    );

    # Setup a nix code formatter
    formatter = libx.forAllSystems (system: self.packages.${system}.nixfmt);

    # Import our custom overlays
    overlays = import ./overlays {inherit inputs;};

    # Systems
    # the hostname must match `scutil --get LocalHostName`
    # `nix build .\#darwinConfigurations.macos.system`
    darwinConfigurations = {
      "macosdev" = libx.mkDarwinConfiguration rec {
        inherit modulesDir;
        system = "aarch64-darwin";
        hostname = "macosdev";
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      };

      # "VCW954LG7G" = libx.mkDarwinConfiguration {
      #   hostname = "VCW954LG7G";
      #   system = "aarch64-darwin";
      # };
    };

    # homeConfigurations = {
    #   "jrizzo@macos" = libx.mkHomeConfiguration {
    #     hostname = "macos";
    #     user = {
    #       user = "jrizzo";
    #       name = "John Rizzo";
    #       email = "johnrizzo1@gmail.com";
    #     };
    #   };

    #   "jrizzo46@VCW954LG7G" = libx.mkHomeConfiguration {
    #     hostname = "VCW95$LG7G";
    #     user = {
    #       user = "jrizzo46";
    #       name = "John Rizzo";
    #       email = "jrizzo46@bloomberg.net";
    #     };
    #   };
    # };

    #
    # Other evaluation checks
    #
    # Derivations
    # checks.system.name
    # cdefaultPackage.system
    #
    # App definitions
    # apps.system.name
    # defaultApp.system
    #
    # Template definitions
    # templates.name
    # defaultTemplate
    #
    # Bundlers
    # bundlers.name
    # defaultBundler
    #
    # NixOS Modules
    # nixosModule
    # nixosModules.name
  };
}
