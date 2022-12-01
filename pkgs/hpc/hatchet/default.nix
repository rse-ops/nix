{ lib
, stdenv
, pkgs
, maintainers
, python38Packages
, python38
}:

python38Packages.buildPythonPackage rec {
  pname = "hatchet";
  version = "1.3.0";

  src = python38Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-14VxvmTjeo0HFOHNRcn5sRgWUODUuN8oiz7UeBZn9GE=";
  };

  propagatedBuildInputs = [
    pkgs.python38Packages.setuptools
    pkgs.python38Packages.matplotlib
    pkgs.python38Packages.pandas
    pkgs.python38Packages.numpy
    pkgs.python38Packages.pyyaml
    pkgs.python38Packages.pydot
  ];

  # Only support for Python 3
  doCheck = !python38Packages.isPy27;

  pythonImportsCheck = [
    "hatchet"
  ];

  meta = with lib; {
    description = "Graph-indexed Pandas DataFrames for analyzing hierarchical performance data";
    homepage = "https://github.com/hatchet/hatchet";
    license = licenses.mit;
    maintainers = [ maintainers.vsoch ];
  };
}
