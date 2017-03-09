{ nixpkgs ? <nixpkgs>, basePythonPackages ? null }:
let
  pkgs = (import nixpkgs) {};
  maintainer = "Joel Rivera <rivera@joel.mx>";
in
let
  pythonPkgs = let
    defaultPythonPackages = (
      if basePythonPackages == null
      then pkgs.pythonPackages 
      else basePythonPackages
    );
    pythonPackagesWith = pp: pkgs.callPackage ./pkgs/python-packages {
      pythonPackages = pp;
      cyraxpkgs = self;
      inherit pkgs maintainer;
     }; in
     rec {
       python27Packages = pythonPackagesWith pkgs.python27Packages;
       python34Packages = pythonPackagesWith pkgs.python34Packages; 
       python35Packages = pythonPackagesWith pkgs.python35Packages; 
         pythonPackages = pythonPackagesWith defaultPythonPackages;
     };
  self = rec {
   ta-lib = pkgs.callPackage ./pkgs/ta-lib { inherit pkgs maintainer; };
  } // pythonPkgs;
in
  self
