{ pkgsPath ? <nixpkgs>,
  basePythonPackages ? null,
  system ? builtins.currentSystem }:
let
  nixpkgs = import pkgsPath {};
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
      cypkgs = self;
      inherit pkgs maintainer;
     }; in {
       python27Packages = pythonPackagesWith pkgs.python27Packages;
       python34Packages = pythonPackagesWith pkgs.python34Packages; 
       python35Packages = pythonPackagesWith pkgs.python35Packages; 
         pythonPackages = pythonPackagesWith defaultPythonPackages;
     };
  self = {
   tws-api = pkgs.callPackage ./pkgs/tws-api { inherit pkgs maintainer; };
   ta-lib = pkgs.callPackage ./pkgs/ta-lib { inherit pkgs maintainer; };
  } // pythonPkgs;
in
  self
