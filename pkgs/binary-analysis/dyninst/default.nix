{ lib
, fetchurl
, maintainers
, llvmPackages_14
, cmake
, boost
, libiberty
, elfutils
, libdwarf
, tbb }:

llvmPackages_14.stdenv.mkDerivation rec {
  pname = "dyninst";
  version = "12.2.1";

  src = fetchurl {
    url = "https://github.com/dyninst/dyninst/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-wwSvPGGR6SrNJzUP2bewKJl2eg44q7OgijeKvgHR7wE=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages_14.openmp boost libiberty elfutils libdwarf tbb];
  cmakeFlags = [
            "-DBoost_ROOT_DIR=${lib.getDev boost}"
            "-DElfUtils_ROOT_DIR=${lib.getDev elfutils}"
            "-DLibIberty_ROOT_DIR=${lib.getDev libiberty}"
            "-DTBB_ROOT_DIR=${lib.getDev tbb}"
            #"-DLibIberty_LIBRARIES=${lib.getLib libiberty}/lib"
            "-DUSE_OpenMP=ON"
            "-DENABLE_STATIC_LIBS=NO"
            "-DSTERILE_BUILD=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/dyninst/dyninst";
    description = ''
      Tools for binary instrumentation, analysis, and modification.
    '';
    licencse = licenses.mit;
    platforms = with platforms; linux;
    maintainers = [maintainers.vsoch];
  };
}

