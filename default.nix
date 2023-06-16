with import <nixpkgs> {};
mkShell {
  packages = [
    bashInteractive
    qmk
    via
  ];
}
