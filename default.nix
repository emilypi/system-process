{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, Cabal, cabal-doctest, contravariant
      , doctest, exitcode, filepath, lens, mtl, stdenv, stm, tasty
      , tasty-hunit
      }:
      mkDerivation {
        pname = "classy-process";
        version = "0.1.0.0";
        src = ./.;
        setupHaskellDepends = [ base Cabal cabal-doctest ];
        libraryHaskellDepends = [
          base contravariant exitcode filepath lens mtl stm
        ];
        testHaskellDepends = [
          base doctest exitcode filepath lens tasty tasty-hunit
        ];
        homepage = "https://github.com/emilypi/classy-process";
        description = "A new library for system processes";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
