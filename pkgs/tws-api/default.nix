{ pkgs, maintainer }:
with pkgs;
stdenv.mkDerivation rec {
  name = "twsapi-${version}";
  version = "9.73";
  buildInputs = [ pkgs.unzip ];
  unpackPhase = ''
    mkdir twsapi
    unzip $src -d twsapi
  '';
  installPhase = ''
    out_prefix="$out/usr/src/twsapi"
    mkdir -p $out_prefix
    cp -r twsapi/IBJts/source/CppClient/  $out_prefix/cpp
    cp -r twsapi/IBJts/source/JavaClient/  $out_prefix/java
    cp -r twsapi/IBJts/source/pythonclient/ $out_prefix/python
  '';
  src = fetchurl {
    url = "http://interactivebrokers.github.io/downloads/twsapi_macunix.973.02.zip";
    sha256 = "10gz3az0f209g3g5ipmv55mwm4sfzdrjsqfpn52bcphzc6yyy5xp";
  };
  meta = with lib; {
    homepage = "http://interactivebrokers.github.io/tws-api/";
    description = "Interactive Brokers TWS API";
    longDescription = ''
    The TWS API is a simple yet powerful interface through which IB clients can automate
    their trading strategies, request market data and monitor your account balance and portfolio in real time.
    '';
    license = licenses.unfree;
    maintainers = [ maintainer ];
    platforms = platforms.unix;
  };
}

