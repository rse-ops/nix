{ lib
, stdenv
, pkgs
, adiak
, fetchurl
, python3
, cmake
, maintainers
, withCuda ? false
, withRocm ? false
, withFortran? false
, withOpenmpi? false
, withMpich ? false
, libunwindSupport ? true
, libpfmSupport ? true
, elfutilsSupport ? true
, shared ? !stdenv.hostPlatform.isStatic,
...
}:

# https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/caliper/package.py

let
   onOffBool = b: if b then "ON" else "OFF";
   withMPI = (withMpich == true || withOpenmpi == true);
in

# We can't have both mpis being used (is this the right way to do this?)
assert (withMpich && !withOpenmpi) || (!withMpich && withOpenmpi) || (!withMpich && !withOpenmpi);

stdenv.mkDerivation rec {
  pname = "caliper";
  version = "2.8.0";

  src = fetchurl {
    url = "https://github.com/LLNL/Caliper/archive/v${version}.tar.gz";
    sha256 = "17807b364b5ac4b05997ead41bd173e773f9a26ff573ff2fe61e0e70eab496e4";
  };

  # This means provided natively in Linux I think?
  nativeBuildInputs = [ cmake ];

  # We can eventually add these variants if needed
  # depends_on("sosflow@spack", when="@1.0:1+sosflow")
  # variant("gotcha", default=is_linux, description="Enable GOTCHA support")
  # variant("sampler", default=is_linux, description="Enable sampling support on Linux")
  # variant("sosflow", default=False, description="Enable SOSflow support")
  # variant("fortran", default=False, description="Enable Fortran support")

  buildInputs = [ python3 pkgs.papi adiak ] ++
    lib.optional libpfmSupport pkgs.libpfm ++
    lib.optional libunwindSupport pkgs.libunwind ++
    lib.optional elfutilsSupport pkgs.elfutils ++
    lib.optional withRocm pkgs.rocm-runtime ++
    lib.optional withCuda pkgs.cudatoolkit ++
    lib.optional withFortran pkgs.gfortran ++

    # These shouldn't be both provided
    lib.optional withOpenmpi pkgs.openmpi ++
    lib.optional withMpich pkgs.mpich;

  # TODO how do these translate over (and is it needed)?
  # ("-DPYTHON_EXECUTABLE=%s" % spec["python"].command.path),
  # args.append("-DPAPI_PREFIX=%s" % spec["papi"].prefix)
  # args.append("-DLIBDW_PREFIX=%s" % spec["elfutils"].prefix)
  # args.append("-DLIBPFM_INSTALL=%s" % spec["libpfm4"].prefix)
  # args.append("-DCUDA_TOOLKIT_ROOT_DIR=%s" % spec["cuda"].prefix)
  # technically only works with cuda 10.2+, otherwise cupti is in
  # ${CUDA_TOOLKIT_ROOT_DIR}/extras/CUPTI
  # args.append("-DCUPTI_PREFIX=%s" % spec["cuda"].prefix)
  # args.append("-DROCM_PREFIX=%s" % spec["hsa-rocr-dev"].prefix)
  # args.append("-DSOS_PREFIX=%s" % spec["sosflow"].prefix)

  cmakeFlags = [
       "-DENABLE_MPI=${onOffBool withMPI}"
       "-DBUILD_SHARED_LIBS=${onOffBool shared}"
       "-DWITH_LIBDW=${onOffBool elfutilsSupport}"
       "-DWITH_LIBPFM=${onOffBool libpfmSupport}"
       "-DWITH_FORTRAN=${onOffBool withFortran}"
       "-DWITH_CUPTI=${onOffBool withCuda}"
       "-DWITH_NVTX=${onOffBool withCuda}"
       "-DWITH_ROCTRACER=${onOffBool withRocm}"
       "-DWITH_LIBUNWIND=${onOffBool libunwindSupport}"
       "-DWITH_ROCTX=${onOffBool withRocm}"
       "-DWITH_ADIAK=ON"
       "-DWITH_PAPI=ON"
       "-DWITH_SAMPLER=ON"
       "-DWITH_GOTCHA=OFF"
       "-DWITH_SOSFLOW=OFF"
       "-DBUILD_TESTING=OFF"
       "-DBUILD_DOCS=OFF"
  ];

  meta = with lib; {
    description = "Program instrumentation and performance measurement framework";
    longDescription = ''
      A program instrumentation and performance measurement
      framework. It is designed as a performance analysis toolbox in a
      library, allowing one to bake performance analysis capabilities
      directly into applications and activate them at runtime.
    '';
    homepage = "https://github.com/LLNL/Caliper";
    license = licenses.bsd3;
    maintainers = [ maintainers.vsoch ];
    platforms = platforms.linux;
  };

}
