{ cypkgs ? ./.
, nixpkgs ? <nixpkgs>
, system ? builtins.currentSystem 
}:
let pkgs = import nixpkgs  {config = { allowUnfree = true;}; inherit system; };
in
let 
  localpkgs =  import cypkgs { nixpkgs = pkgs; };
in
  with pkgs; {
    channel = releaseTools.channel {
       name = "cypkgs";
       src = cypkgs;
       constituents = with localpkgs; [ tws-api ta-lib];
       isNixOS = false;
    };
  }
