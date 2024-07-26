{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    gotk4-nix.url = "github:diamondburned/gotk4-nix";
    gotk4-nix.inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      gotk4-nix,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        buildDependencies = with pkgs; [
          gtk4
          gobject-introspection
        ];

        developDependencies = with pkgs; [
          pkg-config
          clang
          clangd-wrapped
          clang-tools
        ];
      in
      {
        devShells.default = gotk4-nix.lib.mkShell {
          base.pname = "gidle-notify";
          pkgs = pkgs;
        };
      }
    );
}
