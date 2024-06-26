{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    zmk-nix = {
      #url = "github:lilyinstarlight/zmk-nix";
      url = "github:Mic92/zmk-nix/west-build-flags";
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
        westBuildFlags = ["-S" "zmk-usb-logging"];

        zephyrDepsHash = "sha256-G4Vy8DdUXax7lKcZZhMuOMIjnPKlnc2jx6UWM+fOW8Q=";

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
