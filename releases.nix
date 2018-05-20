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
  
  sha256 ? (import ./hashes.nix).${platformName}.${platformArchitecture}.${version}
}:
with pkgs;

stdenv.mkDerivation rec {
  name = "bazel-${version}";

  buildInputs = [
    bash
  ];

  nativeBuildInputs = [
    which
    unzip
    makeWrapper
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

  installPhase = ''    
    ${src} \
      --base=$out/base \
      --bin=$out/unsafe_bin

    makeWrapper $out/unsafe_bin/bazel $out/bin/bazel \
      --set BAZEL_SH ${bash}/bin/bash \
      --prefix PATH : ${lib.makeBinPath [ ]}
  '';
}
