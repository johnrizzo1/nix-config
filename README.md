## Layout
```
.
├── dock               # MacOS dock configuration
├── casks.nix          # List of homebrew casks
├── default.nix        # Defines module, system-level config
├── files.nix          # Non-Nix, static configuration files (now immutable!)
├── home-manager.nix   # Defines user programs
├── packages.nix       # List of packages to install for MacOS
├── secrets.nix        # Age-encrypted secrets with agenix
```

## Shared
Much of the code running on MacOS or NixOS is actually found here.

This configuration gets imported by both modules. Some configuration examples include `git`, `zsh`, `vim`, and `tmux`.

## Layout
```
.
├── config             # Config files not written in Nix
├── cachix             # Defines cachix, a global cache for builds
├── default.nix        # Defines how we import overlays
├── files.nix          # Non-Nix, static configuration files (now immutable!)
├── home-manager.nix   # The goods; most all shared config lives here
├── packages.nix       # List of packages to share
```
# nix-config2
