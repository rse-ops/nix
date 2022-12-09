{ lib
, pkgs
, stdenv
, python3Packages
, maintainers
}:

# TODO maybe should not build this from pypi

python3Packages.buildPythonApplication rec {
  pname = "textX";
  version = "3.0.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-zUMq24LjSJYM7Nyr5o27kW/m6y5MsGfEpLaLjJ7FGs8=";
  };

  propagatedBuildInputs = [
      pkgs.textX
      python3Packages.arpeggio
      python3Packages.future
  ];

  pythonImportsCheck = [
    "textx"
  ];

  # Only support for Python 3
  doCheck = !python3Packages.isPy27;

  meta = with lib; {
    description = "Domain-Specific Languages and parsers in Python made easy.";
    homepage = "https://pypi.org/project/textX/";
    license = licenses.mit;
    maintainers = [ maintainers.vsoch ];
  };

}
