{ buildGoModule }:

let
  src = ../../../.;
in
buildGoModule {
  pname = "quotes-app-go-nix";
  version = "0.1.0";

  src = src;
  # This must be updated when `go.mod` or `go.sum` are changed.
  vendorHash = "sha256-8wYERVt3PIsKkarkwPu8Zy/Sdx43P6g2lz2xRfvTZ2E=";

  postInstall = ''
    mv $out/bin/quotes-app-go $out/bin/quotes-app-go-nix
  '';
}
