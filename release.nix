{ nixpkgs,
  system ? builtins.currentSystem
}:
let
  pkgs = import nixpkgs { inherit system; };
  cypkgs = import ./default.nix { inherit nixpkgs; };
  pythonPackages = with pkgs.lib;
     zipLists [ "py27"  "py34" "py35" ]
     [ cypkgs.python27Packages
       cypkgs.python34Packages
       cypkgs.python35Packages ];
                                                                        
   extra_packages = with pkgs.lib;
      map(e:
          let version = e.fst;
              packages = e.snd;
          in
            mapAttrs(name: drv:
              { "${version}-${name}" = drv; })
              (filterAttrs (n: v: isDerivation v) packages)) pythonPackages;
in
{
  ta-lib = cypkgs.ta-lib;
  extra = extra_packages;
  pp = pythonPackages;
} 

