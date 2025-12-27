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
                nushell
              ]
            );

            shellHook = ''
              echo "nushell   `nu -v`"
              exec nu --config ./config.nu
            '';
          };
        }
      );
    };
}
