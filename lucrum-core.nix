{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7101" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, hspec, HUnit, persistent
      , persistent-postgresql, persistent-sqlite, persistent-template
      , QuickCheck, stdenv, test-framework, test-framework-hunit
      , test-framework-quickcheck2
      }:
      mkDerivation {
        pname = "lucrum-core";
        version = "0.1.0.0";
        src = ./.;
        buildDepends = [
          base persistent persistent-postgresql persistent-sqlite
          persistent-template
        ];
        testDepends = [
          base hspec HUnit QuickCheck test-framework test-framework-hunit
          test-framework-quickcheck2
        ];
        license = stdenv.lib.licenses.mit;
      };

  drv = pkgs.haskell.packages.${compiler}.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
