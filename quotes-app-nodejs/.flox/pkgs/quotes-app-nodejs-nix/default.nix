{
  buildNpmPackage,
  importNpmLock,
}:
let
  pname = "quotes-app";
  nix-build = buildNpmPackage {
    pname = pname;
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

      # result of the build hook
      # Todo: set location in build hook
      mv ./dist $out/lib/node_modules/quotes-app/dist
      mv $out/lib/node_modules/quotes-app/quotes.json $out/lib/node_modules/quotes-app/dist/quotes.json

      echo "#!/usr/bin/env sh" >  $out/bin/quotes-app-nodejs-nix
      echo "exec node $out/lib/node_modules/quotes-app/dist/index.js \"\$@\"" >> $out/bin/quotes-app-nodejs-nix
      chmod 755 $out/bin/quotes-app-nodejs-nix
    '';
  };
in
nix-build
