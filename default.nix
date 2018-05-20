{ pkgs ? import <nixpkgs> {} }:
with pkgs;

stdenv.mkDerivation rec {
  name = "env";

  bazel = import ./releases.nix { version = "0.12.0"; };

  shellHook =
    ''
    export IS_IN_NIX=true
    '';

  buildInputs = [
    bazel
  ];
}
