{
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "quotes-app-python-pyproject-nix";
  version = "0.1.0";
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
    numpy
  ];

  postInstall = ''
    mv $out/bin/quotes-app-python-pyproject $out/bin/quotes-app-python-pyproject-nix
  '';
}
