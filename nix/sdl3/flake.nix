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
        ];

        SDL3-v3_2_28 = pkgs.fetchFromGitHub {
          owner = "libsdl-org";
          repo = "SDL";
          rev = "7f3ae3d57459e59943a4ecfefc8f6277ec6bf540";
          hash = "sha256-nfnvzog1bON2IaBOeWociV82lmRY+qXgdeXBe6GYlww=";
        };
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
            cp -r ${src}/. .
            mkdir -p vendored
            cp -r ${SDL3-v3_2_28}/. vendored/SDL
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
