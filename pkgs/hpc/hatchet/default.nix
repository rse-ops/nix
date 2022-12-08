{ lib
, stdenv
, pkgs
, maintainers
, fetchurl
, caliper-reader
}:

pkgs.python3Packages.buildPythonApplication rec {
  pname = "hatchet";
  version = "2022.2.2";

  src = fetchurl {
    url = "https://github.com/LLNL/hatchet/archive/v${version}.tar.gz";
    sha256 = "sha256-5dQJH45hcBAIjitS9tH4AOwpp4YcLy6WRktCMXD719Y=";
  };

  nativeBuildInputs = [
    pkgs.python3Packages.cython
    pkgs.python3Packages.setuptools
  ];

  propagatedBuildInputs = [
    pkgs.python3Packages.multiprocess
    pkgs.python3Packages.matplotlib
    pkgs.python3Packages.pandas
    pkgs.python3Packages.numpy
    pkgs.python3Packages.pyyaml
    pkgs.python3Packages.pydot
    caliper-reader
  ];

  # Only support for Python 3
  doCheck = !pkgs.python3Packages.isPy27;

  pythonImportsCheck = [
    "hatchet"
  ];

  meta = with lib; {
    description = "Graph-indexed Pandas DataFrames for analyzing hierarchical performance data";
    homepage = "https://github.com/LLNL/hatchet";
    license = licenses.mit;
    maintainers = [ maintainers.vsoch ];
  };
}
