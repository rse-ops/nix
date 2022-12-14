# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays
  maintainers = import ./maintainers.nix;

  adiak = pkgs.callPackage ./pkgs/hpc/adiak {
    inherit maintainers;
  };
  caliper = pkgs.callPackage ./pkgs/hpc/caliper {
    inherit adiak;
    inherit maintainers;
  };
  conduit = pkgs.callPackage ./pkgs/hpc/conduit {
    inherit maintainers;
  };
  conveyorlc = pkgs.callPackage ./pkgs/hpc/conveyorlc {
    inherit conduit;
    inherit maintainers;
  };
#  dyninst = pkgs.callPackage ./pkgs/binary-analysis/dyninst {
#    inherit maintainers;
#  };
  flux-core = pkgs.callPackage ./pkgs/hpc/flux-core {
    inherit maintainers;
  };
  flux-sched = pkgs.callPackage ./pkgs/hpc/flux-sched {
    inherit flux-core;
    inherit maintainers;
  };
}
