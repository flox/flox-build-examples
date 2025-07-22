{ rustPlatform, lib }:
let
  src = ../../../.;
in
rustPlatform.buildRustPackage {
  pname = "quotes-app-rust-nix";
  version = "0.0.1";
  src = src;
  cargoLock = {
    lockFile = src + "/Cargo.lock";
  };

  postInstall = ''
    mv $out/bin/quotes-app-rust $out/bin/quotes-app-rust-nix
  '';
}
