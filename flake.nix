{
  description = "Setting up environment for Programming ZKPs: From Zero to Hero";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "Zero Knowledge Proof Development Shell";
          buildInputs =
            [
              pkgs.rustup
              pkgs.cargo
              pkgs.just
              pkgs.nodejs
              pkgs.circom
              pkgs.toilet
              (pkgs.buildNpmPackage {
                name = "SnarkJS";
                src = pkgs.fetchFromGitHub {
                  owner = "iden3";
                  repo = "snarkjs";
                  rev = "v0.7.4";
                  sha256 = "sha256-EUel+sVUR4GefZKa1fdFWCn8PDgxIIZgf6/6t6MILP0=";
                };
                npmDepsHash = "sha256-H2Mo6CevYGtuwjc0JkSkHYoRbaunHqkA+gk8G9cwStE=";
              })
            ];
            shellHook = ''
              toilet -f mono12  -F metal "ZKP"
              echo "Have fun with the Zero Knowledge Proof tutorial."
              echo "  - https://zkintro.com/articles/programming-zkps-from-zero-to-hero"
              echo
              echo "Tools installed:"
              echo "  - circom : `circom --version`"
              echo "  - snarkjs: `snarkjs | head -n 1`"
              echo "-======================================================================-"
            '';
        };
      }
    );
}
