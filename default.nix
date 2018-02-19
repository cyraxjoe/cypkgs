{ nixpkgs ? (import <nixpkgs> {})
 , basePythonPackages ? null }:
let
  maintainer = "Joel Rivera <rivera@joel.mx>";
in
let
  pythonPkgs = let
    defaultPythonPackages = (
      if basePythonPackages == null
      then nixpkgs.pythonPackages 
      else basePythonPackages
    );
    pythonPackagesWith = pp: nixpkgs.callPackage ./pkgs/python-packages {
      pythonPackages = pp;
      cypkgs = self;
      pkgs = nixpkgs;
      inherit maintainer;
     }; in with nixpkgs; {
       python27Packages = pythonPackagesWith python27Packages;
       python34Packages = pythonPackagesWith python34Packages; 
       python35Packages = pythonPackagesWith python35Packages; 
       python36Packages = pythonPackagesWith python36Packages; 
         pythonPackages = pythonPackagesWith defaultPythonPackages;
       inherit python27 python34 python35 python36; 
     };
  self = with nixpkgs; {
   tws-api = callPackage ./pkgs/tws-api { pkgs=nixpkgs; inherit maintainer; };
   ta-lib = callPackage ./pkgs/ta-lib { pkgs=nixpkgs; inherit maintainer; };

  } // pythonPkgs;
in
  self
