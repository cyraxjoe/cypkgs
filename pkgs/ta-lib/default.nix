{ pkgs, maintainer }:
with pkgs;
stdenv.mkDerivation rec {
  name = "ta-lib-${version}";
  version = "0.4.0";
  src = fetchurl {
    url = "mirror://sourceforge/ta-lib/${name}-src.tar.gz";
    sha256 = "0lf69nna0aahwpgd9m9yjzbv2fbfn081djfznssa84f0n7y1xx4z";
  };

  # the current version uses some insecure printf calls.
  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = "http://ta-lib.org/";
    description ="Common functions for the technical analysis of stock/future/commodity market data";
    license = licenses.bsdOriginal;
    maintainers = [ maintainer ];
    platforms = platforms.all;
  };
}

