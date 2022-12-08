{ lib
, stdenv
, python3Packages
, maintainers
, caliper
}:

# TODO maybe should not build this from pypi

python3Packages.buildPythonApplication rec {
  pname = "caliper-reader";
  version = "0.3.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-/AHf9SewztBRrcK9NeUIV7OfARRyZJwkGIStmhbZVxc=";
  };

  propagatedBuildInputs = [ caliper ];
  pythonImportsCheck = [
    "caliperreader"
  ];

  # Only support for Python 3
  doCheck = !python3Packages.isPy27;

  meta = with lib; {
    description = "caliper-reader: A Python reader for Caliper files";
    homepage = "https://github.com/LLNL/Caliper";
    license = licenses.bsd3;
    maintainers = [ maintainers.vsoch ];
  };

}
