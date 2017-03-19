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
  

  py-trello = buildPythonPackage rec {
    name = "py-trello-0.9.0";
    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/af/64/231f0bcc232d6bf83395f6fc92cf9f7566ee4d67c259b8c67f8cb7e15327/py-trello-0.9.0.tar.gz";
      sha256 = "90de8a27c9f97ad769f1e3fd7d0b59b54f4ad12028b915a3deec1d7fb2594e92";
    };
    doCheck = false;
    propagatedBuildInputs = [ dateutil pytz requests2 requests_oauthlib ];
    meta = with pkgs.stdenv.lib; {
      homepage = "https://github.com/sarumont/py-trello";
      license = licenses.bsdOriginal;
      description = "Python wrapper around the Trello API";
      maintainers = [ maintainer ];
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

    meta = with pkgs.stdenv.lib; {
      description = "Python wrapper for TA-Lib";
      homepage = "http://github.com/mrjbq7/ta-lib";
      license = licenses.bsdOriginal;
      maintainers = [ maintainer ];
    };
  };

}
