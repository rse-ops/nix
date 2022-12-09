{ lib
, stdenv
, fetchurl
, pkgs
, maintainers
, flux-core
}:

let
   boost = pkgs.boost.override { enableShared = false; enabledStatic = true; };
in

stdenv.mkDerivation rec {
  pname = "flux-sched";
  version = "0.25.0";

  src = fetchurl {
    url = "https://github.com/flux-framework/flux-sched/releases/download/v${version}/flux-sched-${version}.tar.gz";
    sha256 = "a984b238d8b6968ef51f1948a550bf57887bf3da8002dcd1734ce26afc4bff07";
  };

  nativeBuildInputs = [
    pkgs.bash
    pkgs.pkgconfig
    #pkgs.autoconf
    #pkgs.automake
    #pkgs.libtool
  ];

  buildInputs = [
    pkgs.cudatoolkit
    pkgs.boost
    pkgs.boost-build
    pkgs.boost_process
    pkgs.boost-sml
    pkgs.python310Packages.pyyaml
    pkgs.python310Packages.jsonschema
    pkgs.hwloc
    pkgs.libedit
    pkgs.libxml2
    pkgs.libyamlcpp
    pkgs.jansson
#    pkgs.zmqpp
    pkgs.czmq
    pkgs.libuuid
    pkgs.python310
    flux-core
  ];

  # A native nix build won't have /bin/bash or possibly /usr/env/bin bash
  #preConfigure = ''
  # sed -i '1d' ./etc/completions/get_builtins.sh;
  #'';

  configureFlags = [
     "--with-boost-libdir=${lib.getDev pkgs.boost-sml}"
  ];
#  cmakeFlags = [
#    "-DCONDUIT_DIR=${lib.getDev conduit}"
#    "-DCONDUIT_FOUND=TRUE"
#    "-DCONDUIT_INCLUDE_DIRS=${lib.getDev conduit}/include/conduit"
#    "-DCONDUIT_CMAKE_CONFIG_DIR=${lib.getDev conduit}/lib/cmake/conduit"
#    "-DCMAKE_CXX_FLAGS=-lhdf5"
#    "-DHDF5_ROOT=${lib.getDev pkgs.hdf5-cpp}"
#    "-DOPENBABEL3_INCLUDE_DIRS=${lib.getDev pkgs.openbabel2}/include/openbabel-2.0"
#  ];

  meta = with lib; {
    description = "A next-generation resource manager.";
    homepage = "https://github.com/flux-framework/flux-core";
    license = licenses.lgpl3;
    maintainers = [ maintainers.vsoch ];
  };
}
