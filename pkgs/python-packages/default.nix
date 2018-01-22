{ cypkgs, pkgs, maintainer, pythonPackages}:
with pythonPackages;
let fetchurl = pkgs.fetchurl;  in
{

  awake = buildPythonPackage rec {
    name = "awake-${version}";
    version = "1.0";
    doCheck = false;
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/a/awake/${name}.tar.gz";
      sha256 = "a4be9058c08ed702b700c9e10e270a7355ba1563f22ad6b2dbd334c6bb5a1730";
    };
    meta = with pkgs.stdenv.lib; {
      license = licenses.gpl3;    
      maintainers = [ maintainer ];
      platforms = platforms.all;
      description = "Command and library to WOL a remote host.";
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
    meta = with pkgs.stdenv.lib; {
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

  pypfop = import ./pypfop.nix { inherit pkgs maintainer pythonPackages; };
  
  TA-Lib = buildPythonPackage rec {
    name = "TA-Lib-${version}";
    version = "0.4.16";
    disabled = isPyPy;
    doCheck = false;
    src = fetchurl {
      url = "mirror://pypi/T/TA-Lib/${name}.tar.gz";
      sha256 = "555f5d9e6720ef935669c1f404a7179091ae35869c6435957709a7059b9fd1d7";
    };
    buildInputs = [ cypkgs.ta-lib ];
    propagatedBuildInputs = [ numpy cython ];

    meta = with pkgs.stdenv.lib; {
      description = "Python wrapper for TA-Lib";
      homepage = "http://github.com/mrjbq7/ta-lib";
      license = licenses.bsdOriginal;
      maintainers = [ maintainer ];
    };
  };

}
