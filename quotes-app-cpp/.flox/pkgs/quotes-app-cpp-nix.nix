{ clangStdenv, boost, lib }:

clangStdenv.mkDerivation rec {
  pname = "quotes-app-cpp";
  version = "0.0.1";

  src = ../../.;

  buildInputs = [ boost ];

  installFlags = [ "PREFIX=$(out)" "SUFFIX=-nix" ];

  meta = with lib; {
    description = "Quotes app written in C++";
  };
}
