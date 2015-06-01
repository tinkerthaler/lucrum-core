# Template file!
{ cabal }:

cabal.mkDerivation (self: {
  pname = "lucrum-core";
  version = "0.1.0.0";
  src = ./.;
  buildDepends = [];
  extraLibraries = [];
  configureFlags = [];
  meta = {
    license = self.stdenv.lib.licences.unfree;
    platforms = self.ghc.meta.platforms;
  };
})
