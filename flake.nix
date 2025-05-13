{
  inputs = {
    nixpkgs.url = "git+https://github.com/Mic92/nixpkgs?shallow=1&ref=main";

    zmk-nix = {
      url = "github:lilyinstarlight/zmk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, zmk-nix }: let
    forAllSystems = nixpkgs.lib.genAttrs (nixpkgs.lib.attrNames zmk-nix.packages);
  in {
    packages = forAllSystems (system: rec {
      default = firmware;

      firmware = zmk-nix.legacyPackages.${system}.buildSplitKeyboard {
        name = "firmware";

        src = nixpkgs.lib.traceVal (builtins.toString (nixpkgs.lib.sourceFilesBySuffices self [ ".conf" ".keymap" ".dtsi" ".yml" ]));

        board = "nice_nano_v2";
        shield = "splitkb_aurora_sofle_%PART% nice_view_adapter nice_view";

        zephyrDepsHash = "sha256-C1BVxqgv4M7elkAlxXWwacEML2JTKZvRCLrgIMK9OtU=";

        meta = {
          description = "ZMK firmware";
          license = nixpkgs.lib.licenses.mit;
          platforms = nixpkgs.lib.platforms.all;
        };
      };

      flash = zmk-nix.packages.${system}.flash.override { inherit firmware; };
      update = zmk-nix.packages.${system}.update;
    });

    devShells = forAllSystems (system: {
      default = zmk-nix.devShells.${system}.default;
    });
  };
}
