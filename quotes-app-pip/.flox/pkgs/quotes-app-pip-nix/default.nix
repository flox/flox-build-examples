{
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "quotes-app-pip-nix";
  version = "0.0.1";
  pyproject = true;

  src = builtins.path {
    name = "src";
    path = ./../../..;
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    fastapi
    uvicorn
  ];

  postInstall = ''
    mv $out/bin/quotes-app-pip $out/bin/quotes-app-pip-nix
  '';
}
