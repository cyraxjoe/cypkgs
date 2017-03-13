{ cypkgs, pkgs, maintainer, pythonPackages}:
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
  
  TA-Lib = buildPythonPackage rec {
    name = "TA-Lib-${version}";
    version = "0.4.10";
    disabled = isPyPy;
    doCheck = false;
    src = fetchurl {
      url = "mirror://pypi/T/TA-Lib/${name}.tar.gz";
      sha256 = "0a7mkxcy3qf3w1wbi6gaarpa3zvqy7s73xais9iia2fk17dxwdqi";
    };
    buildInputs = [ cypkgs.ta-lib ];
    propagatedBuildInputs = [ numpy cython ];

    meta = {
      description = "Python wrapper for TA-Lib";
      homepage = "http://github.com/mrjbq7/ta-lib";
      license = lib.licenses.bsdOriginal;
      maintainers = [ maintainer ];
    };
  };

  ibapi = if (pythonAtLeast "3.2" ) then buildPythonPackage rec {
    name = "ibapi-${version}";
    version = "9.73";
    buildInputs = [ pkgs.unzip ];
    sourceRoot = "IBJts/source/pythonclient/";
    src = fetchurl {
      url = "http://interactivebrokers.github.io/downloads/twsapi_macunix.973.02.zip";
      sha256 = "10gz3az0f209g3g5ipmv55mwm4sfzdrjsqfpn52bcphzc6yyy5xp";
    };
    meta = with lib; {
      homepage = "http://interactivebrokers.github.io/tws-api/";
      description = "Interactive Brokers Python TWS API";
      longDescription = ''
      The TWS API is a simple yet powerful interface through which IB clients can automate
      their trading strategies, request market data and monitor your account balance and portfolio in real time.
      '';
      license = licenses.unfree;
      maintainers = [ maintainer ];
      platforms = platforms.unix;
    };
  } else null;
}
