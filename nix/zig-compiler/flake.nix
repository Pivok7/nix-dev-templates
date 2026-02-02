{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell rec {
          packages = with pkgs; [
            cmake
            ninja

            libclang
            lld
            llvm
            libxml2

            zlib
            pkgs.stdenv.cc.cc.lib

            qemu
            wasmtime
          ];

          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath packages}";

          shellHook = ''
            echo "cmake .. \
            -DCMAKE_BUILD_TYPE=Release \
            -GNinja \
            -DZIG_NO_LIB=ON \
            -DCLANG_INCLUDE_DIRS=${pkgs.lib.makeLibraryPath [ pkgs.libclang ]} \
            -DLLD_INCLUDE_DIRS=${pkgs.lib.makeLibraryPath [ pkgs.lld ]} \
            "
          '';
        };
      }
    );
}
