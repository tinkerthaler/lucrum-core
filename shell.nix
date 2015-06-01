let 
  pkgs = import <nixpkgs> {};
  haskellPackages = pkgs.haskellPackages.override {
    extension = self: super: {
      lucrum-core = self.callPackage ./lucrum-core.nix {};
    };
  };
  name = "lucrum-core";
  stdenv = pkgs.stdenv;
in stdenv.mkDerivation {
  extraLibraries = [];
  configureFlags = [];
  buildInputs = [
    (haskellPackages.ghcWithPackagesOld (hs: ([
      hs.cabalInstall
      hs.hscolour
      hs.hoogle
      hs.haddock
      hs.HUnit
    ]
    ++ hs.lucrum-core.propagatedNativeBuildInputs
    )))
    pkgs.python
    pkgs.libxml2
    pkgs.postgresql
  ];  
  inherit name;
  ME_ENV = "Hello";
}
