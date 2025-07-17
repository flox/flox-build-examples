{
  python312Packages,
}:

python312Packages.buildPythonApplication {
  pname = "quotes-app-pip-nix";
  version = "0.0.1";
  pyproject = true;

  src = builtins.path {
    name = "src";
    path = ./../../..;
  };

  build-system = with python312Packages; [
    setuptools
  ];

  dependencies = with python312Packages; [
    fastapi
    uvicorn
  ];
}
