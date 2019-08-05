{ mkDerivation, base, diagrams-lib, diagrams-svg
, optparse-applicative, split, stdenv
}:
mkDerivation {
  pname = "gen-dmc";
  version = "0.1.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base diagrams-lib diagrams-svg optparse-applicative split
  ];
  homepage = "https://github.com/kmein/gen-dmc";
  description = "RUN DMC style logo generator";
  license = stdenv.lib.licenses.mit;
}
