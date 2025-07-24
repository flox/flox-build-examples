{
  buildNpmPackage,
  importNpmLock,
}:
let
  nix-build = buildNpmPackage (final: {
    pname = "quotes-app";
    version = "0.1.0";
    src = ../../../.;

    npmDeps = importNpmLock {
      npmRoot = final.src;
    };

    npmConfigHook = importNpmLock.npmConfigHook;

    npmBuildScript = "build";

    # Add launcher binary
    postInstall = ''
      mkdir -p $out/bin

      mv $out/lib/node_modules/${final.pname}/quotes.json $out/lib/node_modules/${final.pname}/dist/quotes.json

      echo "#!/usr/bin/env sh" >  $out/bin/quotes-app-nodejs-nix
      echo "exec node $out/lib/node_modules/${final.pname}/dist/index.js \"\$@\"" >> $out/bin/quotes-app-nodejs-nix
      chmod 755 $out/bin/quotes-app-nodejs-nix
    '';
  });
in
nix-build
