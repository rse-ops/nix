{ lib, stdenv, pkgs, fetchurl, fetchFromGitHub, cmake, maintainers, conduit
, shared ? !stdenv.hostPlatform.isStatic,
...
}:

let
   onOffBool = b: if b then "ON" else "OFF";
in


stdenv.mkDerivation rec {
  pname = "conveyorlc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "XiaohuaZhangLLNL";
    repo = "conveyorlc";
    rev = "efb98b021edd5ef230eaff257ce2534ea01ab1ba";
    sha256 = "sha256-L/pWqKFM1/68X9HPHKMBYODlDI3Jh4IVqffDGjVNCrc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [cmake pkgs.extra-cmake-modules];
  buildInputs = [pkgs.boost172 pkgs.openmpi pkgs.zlib pkgs.hdf5 conduit];

  cmakeFlags = [
    "-DCONDUIT_DIR=${lib.getDev conduit}"
  ];

  meta = with lib; {
    description = "A Parallel Virtual Screening Pipeline for Docking and MM/GSBA";
    longDescription = ''
      An open source project from Lawrence Livermore National
      Laboratory that provides a parallel virtual screening pipeline
      for docking and MM/GSBA
    '';
    homepage = "https://github.com/XiaohuaZhangLLNL/conveyorlc";
    license = licenses.gpl3;
    maintainers = [ maintainers.vsoch ];
    platforms = platforms.linux;
  };
}
