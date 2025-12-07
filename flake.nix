{
  description = "Python flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forEachSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = (
              with pkgs;
              [
                python3
                python3Packages.numpy
              ]
            );
          };
        }
      );

      packages = forEachSystem (
        { pkgs }:
        {
          default = pkgs.python3Packages.buildPythonApplication {
            pname = "python-app";
            version = "0.1.0";

            pyproject = true;

            src = ./.;

            build-system = with pkgs.python3Packages; [
              setuptools
              wheel
            ];

            propagatedBuildInputs = with pkgs.python3Packages; [
              numpy
            ];
          };
        }
      );
    };
}
