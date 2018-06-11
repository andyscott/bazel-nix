params @ {
  pkgs ? import <nixpkgs> {},

  version ? null,
  platformName ? null,
  platformArchitecture ? null,
  sha256 ? null,
  bazelPathInputs ? [null],
  ...
}:
with pkgs;

stdenv.mkDerivation rec {
  name = "bazel";

  src = builtins.filterSource (path: type: false) ./.;
  
  bazel =
    if params ? "version" then
      (import ./bazel-release.nix params)
    else
      builtins.trace params
      (import ./bazel-release.nix params);

  buildInputs = [
    bazel    
  ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s $bazel/bin/bazel $out/bin/bazel
  '';
}
