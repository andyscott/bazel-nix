{
  pkgs ? import <nixpkgs> {},

  version,
  
  platformName ? {
    "x86_64-linux" = "linux";
    "x86_64-darwin" = "darwin";
  }.${builtins.currentSystem},
  
  platformArchitecture ? {
    "x86_64-linux" = "x86_64";
    "x86_64-darwin" = "x86_64";
  }.${builtins.currentSystem},
  
  sha256 ? (import ./bazel-release-hashes.nix).${platformName}.${platformArchitecture}.${version},

  bazelPathInputs ? [
    pkgs.coreutils
    pkgs.bash
    pkgs.which
    pkgs.gnugrep
    pkgs.gawk
    pkgs.gnused    
  ]
}:
with pkgs;

stdenv.mkDerivation rec {
  name = "bazel-release-${version}";

  nativeBuildInputs = [
    which    
    unzip
    makeWrapper
    bazelBash
  ];

  phases = "installPhase";

  remoteSource = "https://github.com/bazelbuild/bazel/releases/download";
  installerName = "bazel-${version}-installer-${platformName}-${platformArchitecture}.sh";

  installerUrl = "${remoteSource}/${version}/${installerName}";

  src = fetchurl {
    url = installerUrl;
    sha256 = sha256;
    executable = true;
  };

  bazelBash = runCommand "bazel-bash" { buildInputs = [ makeWrapper ]; } ''
    makeWrapper ${bash}/bin/bash $out/bin/bazel-bash \
      --prefix PATH ":" ${lib.makeBinPath bazelPathInputs}
  '';  

  installPhase = ''
    mkdir not-my-home
    HOME=`pwd`/not-my-home ${src} \
      --base=$out/base \
      --bin=$out/unwrapped_bin
    rm -r not-my-home

    makeWrapper $out/unwrapped_bin/bazel $out/bin/bazel \
      --set BAZEL_SH ${bazelBash}/bin/bazel-bash
  '';
}
