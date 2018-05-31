{
  pkgs ? import <nixpkgs> {},

  version ? "0.12.0",
  
  platformName ? {
    "x86_64-linux" = "linux";
    "x86_64-darwin" = "darwin";
  }.${builtins.currentSystem},
  
  platformArchitecture ? {
    "x86_64-linux" = "x86_64";
    "x86_64-darwin" = "x86_64";
  }.${builtins.currentSystem},
  
  sha256 ? (import ./hashes.nix).${platformName}.${platformArchitecture}.${version},

  bazelBashInputs ? [ pkgs.coreutils ]
}:
with pkgs;

stdenv.mkDerivation rec {
  name = "bazel-${version}";  

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
      --prefix PATH ":" ${lib.makeBinPath bazelBashInputs}
  '';  

  installPhase = ''
    mkdir not-my-home
    HOME=`pwd`/not-my-home ${src} \
      --base=$out/base \
      --bin=$out/unsafe_bin
    rm -r not-my-home

    makeWrapper $out/unsafe_bin/bazel $out/bin/bazel \
      --set BAZEL_SH ${bazelBash}/bin/bazel-bash
  '';
}
