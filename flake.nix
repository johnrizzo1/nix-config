{
  description = "multi-user, multi-host nix configuration";

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    # "github:nixos/nixpkgs/nixos-23.11";
    # "github:nixos/nixpkgs/nixos-unstable";
    # "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
    nix-darwin,
    ...
  }: let
    inherit (self) outputs;
    stateVersion = "23.11";
    darwinSystems = ["aarch64-darwin"];
    linuxSystems = ["aarch64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs (darwinSystems ++ linuxSystems) f;
    # libx = import ./lib {inherit inputs outputs stateVersion;};
  in {
    # System Configurations
    # nix build .\#darwinConfigurations.macos.system
    darwinConfigurations."macos" = let
      timezone = "America/New_York";
      user = "jrizzo";
      name = "John Rizzo";
      email = "johnrizzo1@gmail.com";
      specialArgs =
        inputs
        // {
          inherit outputs stateVersion user name email timezone;
        };
    in
      nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        system = "aarch64-darwin";
        modules = [./hosts/macos];
      };

    overlays = import ./overlays {inherit inputs;};

    packages = forAllSystems (
      system: let
        # pkgs = nixpkgs-unstable.legacyPackages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./pkgs {inherit pkgs;}
    );

    # A Dev Shell
    devShells = forAllSystems (
      system: let
        # pkgs = nixpkgs-unstable.legacyPackages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    # Setup a nix code formatter based on format-engine = alejandra or nixfmt
    # formatter = let format-engine = "alejandra"; in
    #   forAllSystems (system: nixpkgs.legacyPackages.${system}.${format-engine});
    formatter = forAllSystems (system: self.packages.${system}.nixfmt);
  };
}
