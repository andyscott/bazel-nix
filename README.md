## Bazel + Nix

To add a new version:
* Find the release in https://github.com/bazelbuild/bazel/releases/
* Download bazel-0.28.1-installer-darwin-x86_64.sh and bazel-0.28.1-installer-linux-x86_64.sh
* `chmod +x` both files
* Use `nix-hash --type sha256 --base32` to compute the hash
* Add the version number and hash to the corresponding sections of bazel-release-hashes.nix
