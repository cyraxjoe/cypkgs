{ cypkgs ? ./.
, nixpkgs ? <nixpkgs>
, system ? builtins.currentSystem 
}:
let pkgs = import nixpkgs  {config = { allowUnfree = true;}; inherit system; };
in
let 
  localpkgs =  import cypkgs { nixpkgs = pkgs; };
in
  with pkgs; rec {
    channel = releaseTools.channel {
       name = "cypkgs";
       src = cypkgs;
       constituents = [ tws-api ta-lib ];
       isNixOS = false;
    };
    inherit (localpkgs) tws-api ta-lib;
  }
