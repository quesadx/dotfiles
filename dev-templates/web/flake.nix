{
  description = "Web Development Environment: Node.js";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs_25
          nodePackages.pnpm
        ];

        shellHook = ''
          echo "Web Development Environment"
          alias dev="pnpm run dev"
          alias build="pnpm run build"
        '';
      };
    };
}
