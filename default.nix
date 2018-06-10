params @ {
  pkgs ? import <nixpkgs> {},
  ...
}:

if params ? "version" then
  (import ./bazel-release.nix params)
else
  {}
