{
  description = "SDL3 project flake";
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
        pkgs = import nixpkgs {
          inherit system;
        };
        lib = pkgs.lib;
        stdenv = pkgs.stdenv;

        _nativeBuildInputs = with pkgs; [
          cmake
          pkg-config
          makeWrapper
          wayland-scanner
        ];

        _buildInputs = with pkgs; [
          libGL
          libxkbcommon
          wayland
          alsa-lib
          sdl3
        ];
      in
      {
        devShells.default = pkgs.mkShell rec {
          nativeBuildInputs = _nativeBuildInputs;
          buildInputs = _buildInputs;

          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
        };

        packages.default = stdenv.mkDerivation rec {
          pname = "sdl3-app";
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = _nativeBuildInputs;
          buildInputs = _buildInputs;

          unpackPhase = ''
            cp -r ${src}/src .
            cp -r ${src}/CMakeLists.txt .
          '';

          # This hack is here because SDL3 does dlopen() a lot
          postFixup = ''
            wrapProgram $out/bin/$pname \
              --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
          '';
        };
      }
    );
}
