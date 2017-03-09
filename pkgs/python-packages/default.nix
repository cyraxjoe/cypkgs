{ cyraxpkgs, pkgs, maintainer, pythonPackages}:
with pkgs.stdenv;
let fetchurl = pkgs.fetchurl; in
with pythonPackages;
{
  awake = buildPythonPackage rec {
    name = "awake-${version}";
    version = "1.0";
    doCheck = false;
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/a/awake/${name}.tar.gz";
      md5 = "57b7a2e616e37fc29b4011a2e1cc60b2";
    };
    meta = {
      license = lib.licenses.gpl3;    
      maintainers = [ maintainer ];
      platforms = lib.platforms.all;
    };
  };
  
  awake_0_6_1 = buildPythonPackage rec {
    name = "awake-${version}";
    version = "0.6.1";    
    doCheck = false;
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/a/awake/${name}.tar.gz";
      md5 = "cd54eeb47aadb2b989db1eb28d409e4b";
    };
    meta = {
      license = lib.licenses.gpl3;    
      maintainers = [ maintainer ];
      platforms = lib.platforms.all;
    };

  };

  TA-Lib = buildPythonPackage rec {
    name = "TA-Lib-${version}";
    version = "0.4.10";
    disabled = isPyPy;
    doCheck = false;
    src = fetchurl {
      url = "mirror://pypi/T/TA-Lib/${name}.tar.gz";
      sha256 = "0a7mkxcy3qf3w1wbi6gaarpa3zvqy7s73xais9iia2fk17dxwdqi";
    };
    buildInputs = [ cyraxpkgs.ta-lib ];
    propagatedBuildInputs = [ numpy cython ];

    meta = {
      description = "Python wrapper for TA-Lib";
      homepage = "http://github.com/mrjbq7/ta-lib";
      license = lib.licenses.bsdOriginal;
      maintainers = [ maintainer ];
    };
  };
}
