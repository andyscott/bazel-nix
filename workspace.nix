{ pkgs ? import <nixpkgs> {} }:
with pkgs;

stdenv.mkDerivation rec {
  name = "env";

  src = builtins.filterSource (path: type: false) ./.;
  
  bazel = import ./default.nix {
    version = "0.14.1";    
  };

  buildInputs = [
    bazel
    which
  ];

  installPhase = ''
    mkdir $out
    ln -s $(which bazel) $out/bazel
  '';
}
