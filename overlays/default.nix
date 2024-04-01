{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = _final: _prev: {
    #   # example = prev.example.overrideAttrs (oldAttrs: rec {
    #   # ...
    #   # });

    #   # https://github.com/NixOS/nixpkgs/pull/282595
    #   # https://github.com/NixOS/nixpkgs/pull/285883
    #   # https://github.com/NixOS/nixpkgs/issues/282749
    #   obsidian = prev.obsidian.overrideAttrs (oldAttrs: rec {
    #     installPhase = ''
    #       runHook preInstall
    #       mkdir -p $out/bin
    #       makeWrapper ${prev.electron_25}/bin/electron $out/bin/obsidian \
    #         --set LD_LIBRARY_PATH "${prev.lib.makeLibraryPath [ prev.libGL ]}" \
    #         --add-flags $out/share/obsidian/app.asar \
    #         --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
    #       install -m 444 -D resources/app.asar $out/share/obsidian/app.asar
    #       install -m 444 -D resources/obsidian.asar $out/share/obsidian/obsidian.asar
    #       install -m 444 -D "${oldAttrs.desktopItem}/share/applications/"* \
    #         -t $out/share/applications/
    #       for size in 16 24 32 48 64 128 256 512; do
    #         mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
    #         convert -background none -resize "$size"x"$size" ${oldAttrs.icon} $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
    #       done
    #       runHook postInstall
    #     '';
    #   });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: rec {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
