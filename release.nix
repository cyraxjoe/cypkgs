{ cypkgsPath ? ./.
 ,nixpkgsPath ? <nixpkgs>
 ,system ? builtins.currentSystem
}:
let
    nixpkgs = import nixpkgsPath {
       config = { allowUnfree = true;}; inherit system; 
    };
in
let  
  cypkgs = import cypkgsPath { inherit nixpkgs; };
  # create  a list with list of two elements
  # with a name corresponding to the python version
  # e.g. [[ "py27" cypkgs.python27Packages ] ...]
  pythonPackages = with nixpkgs.lib;  zipLists [ "py27"  "py34" "py35" "py36" ]
                               [ cypkgs.python27Packages
                                 cypkgs.python34Packages
                                 cypkgs.python35Packages
                                 cypkgs.python36Packages ];
  extra_packages = with nixpkgs.lib;
       zipAttrs  (map (e: let version = e.fst;  packages = e.snd; in
         mapAttrs'(name: drv:
                nameValuePair (replaceStrings ["."] ["_"] "${version}-${name}")  drv)
                        # filter the attribute that are indeed packages
                      (filterAttrs (n: v: isDerivation v) packages))
                  pythonPackages);

  jobs =  with nixpkgs.lib; mapAttrs (n: v: head v) extra_packages; 
in
    jobs // (with nixpkgs; {
    ta-lib = cypkgs.ta-lib;
    python36 = python36Full;
    cherrypy = python36Packages.cherrypy;
    pyramid = python36Packages.pyramid;
    pandas = python36Packages.pandas;
    })

