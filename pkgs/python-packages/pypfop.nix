{ pkgs, maintainer, pythonPackages }:
with pythonPackages;
let fetchurl = pkgs.fetchurl; in
let
  deps = {
    mako = buildPythonPackage {
        name = "Mako-1.0.6";
          src = fetchurl {
            url = "https://pypi.python.org/packages/56/4b/cb75836863a6382199aefb3d3809937e21fa4cb0db15a4f4ba0ecc2e7e8e/Mako-1.0.6.tar.gz";
            sha256 = "48559ebd872a8e77f92005884b3d88ffae552812cdf17db6768e5c3be5ebbe0d";
          };
          doCheck = false;
          propagatedBuildInputs = [ markupsafe ];
          meta = with pkgs.stdenv.lib; {
            homepage = "";
            license = licenses.mit;
            description = "A super-fast templating language that borrows the  best ideas from the existing templating languages.";
          };
    };
    markupsafe = buildPythonPackage {
        name = "MarkupSafe-1.0";
        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz";
          sha256 = "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665";
        };
        doCheck = false;
        meta = with pkgs.stdenv.lib; {
          homepage = "";
          license = licenses.bsdOriginal;
          description = "Implements a XML/HTML/XHTML Markup safe string for Python";
        };
      };

    cssselect = buildPythonPackage  {
        name = "cssselect-1.0.1";
        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/77/ff/9c865275cd19290feba56344eba570e719efb7ca5b34d67ed12b22ebbb0d/cssselect-1.0.1.tar.gz";
          sha256 = "73db1c054b9348409e2862fc6c0dde5c4e4fbe4da64c5c5a9e05fbea45744077";
        };
        doCheck = false;
        meta = with pkgs.stdenv.lib; {
          homepage = "";
          license = licenses.bsdOriginal;
          description = "cssselect parses CSS3 Selectors and translates them to XPath 1.0";
        };
      };

    cssutils = buildPythonPackage {
        name = "cssutils-1.0.2";
        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/5c/0b/c5f29d29c037e97043770b5e7c740b6252993e4b57f029b3cd03c78ddfec/cssutils-1.0.2.tar.gz";
          sha256 = "a2fcf06467553038e98fea9cfe36af2bf14063eb147a70958cfcaa8f5786acaf";
        };
        doCheck = false;
        meta = with pkgs.stdenv.lib; {
          homepage = "";
          license = licenses.lgpl2;
          description = "A CSS Cascading Style Sheets library for Python";
        };
      };
  };
  dep_list = builtins.attrValues { inherit(deps) mako cssutils cssselect; };
in buildPythonPackage rec {
  name = "pypfop";
  version = "0.2.0";
  src = fetchurl {
    url = "https://pypi.python.org/packages/f3/98/a5aff66b35f9dc2f58acb7df027f1ae253c1853caf2aafd98da8ed1ef3c7/pypfop-0.2.0.tar.gz";
    sha256 = "12krnival4aw3byw3qdd7fs5nwai105qcvzwdj5sqkw38zjvpgyi";
  };
  propagatedBuildInputs = [ lxml ] ++ dep_list;
  meta = with pkgs.stdenv.lib; {
    homepage = "https://github.com/cyraxjoe/pypfop";
    license = licenses.asl20;
    maintainers = [ maintainer ];
    description = "Python Preprocessor of the Formatting Objects Processor";
  };
 }
