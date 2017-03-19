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
      md5 = "57b7a2e616e37fc29b4011a2e1cc60b2";
    };
    meta = with pkgs.stdenv.lib; {
      license = licenses.gpl3;    
      maintainers = [ maintainer ];
      platforms = platforms.all;
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
    version = "0.4.10";
    disabled = isPyPy;
    doCheck = false;
    src = fetchurl {
      url = "mirror://pypi/T/TA-Lib/${name}.tar.gz";
      sha256 = "0a7mkxcy3qf3w1wbi6gaarpa3zvqy7s73xais9iia2fk17dxwdqi";
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

  trello = buildPythonPackage rec {
    name = "trello-0.9.1";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/15/5e/b39cc09f075766e2f6fd9db63a964eac0db596e68f934fd80bb56b7e1fd2/${name}.zip";
      sha256 = "594f88ea5f2a4edd337747f00fb0acb80116b92c9bbe1c2c3acfa8c891e5b226";
    };
    doCheck = false;
    propagatedBuildInputs = [ requests2 ];
    meta = {
      homepage = "http://trello.com";
      license = "Copyright (c) 2012, Fog Creek Software, Inc.";
      description = "Python library for interacting with the Trello API";
      maintainers = [ maintainer ];
    };
  };


}
