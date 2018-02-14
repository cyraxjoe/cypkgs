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
    tarball =  stdenv.mkDerivation {
        name = "cypkgs-latest";
        src = cypkgsPath; 
        buildInputs = [ git ];
        dontBuild = true;
        dontInstall = true;
        doDist = true;
        postPhases = "finalPhase";
        preUnpack = ''
            mkdir -p $out/nix-support
        '';
        postUnpack = ''
            # Set all source files to the current date.  This is because Nix
            # resets the timestamp on all files to 0 (1/1/1970), which some
            # people don't like (in particular GNU tar prints harmless but
            # frightening warnings about it).
            touch now
            touch -d "1970-01-01 00:00:00 UTC" then
            find $sourceRoot ! -newer then -print0 | xargs -0r touch --reference now
            rm now then
            eval "$nextPostUnpack"
        '';
        # Cause distPhase to copy tar.bz2 in addition to tar.gz.
        tarballs = "*.tar.bz2";
        finalPhase = ''
            for i in "$out/tarballs/"*; do
               echo "file source-dist $i" >> $out/nix-support/hydra-build-products
            done
            # Try to figure out the release name.
            releaseName=$( (cd $out/tarballs && ls) | head -n 1 | sed -e 's^\.[a-z].*^^')
            test -n "$releaseName" && (echo "$releaseName" >> $out/nix-support/hydra-release-name)
        '';
        distPhase = ''
          releaseName="cypkgs-latests"
          mkdir -p $out/tarballs
          mkdir ../$releaseName
          cp -prd . ../$releaseName
          cd ..
          chmod -R u+w $releaseName
          tar  --create --file  $out/tarballs/$releaseName.tar.bz2  --bzip2 --verbose --exclude-vcs $releaseName
        ''; # */

        meta = {
            description = "cypkgs source distribution";
            # Tarball builds are generally important, so give them a high
            # default priority.
            schedulingPriority = 200;
        };
    };
    })

