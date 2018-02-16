{ nixpkgs ? (import <nixpkgs> {})
 ,basePythonPackages ? null }:
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
     }; in {
       python27Packages = pythonPackagesWith nixpkgs.python27Packages;
       python34Packages = pythonPackagesWith nixpkgs.python34Packages; 
       python35Packages = pythonPackagesWith nixpkgs.python35Packages; 
       python36Packages = pythonPackagesWith nixpkgs.python36Packages; 
         pythonPackages = pythonPackagesWith defaultPythonPackages;
     };
  self = with nixpkgs; {
   tws-api = callPackage ./pkgs/tws-api { pkgs=nixpkgs; inherit maintainer; };
   ta-lib = callPackage ./pkgs/ta-lib { pkgs=nixpkgs; inherit maintainer; };
   netcat  = netcat; # test
   hello  = hello; # test
  } // pythonPkgs;
in
  self
