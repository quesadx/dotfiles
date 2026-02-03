{
  description = "Web Development Environment (Node.js + TypeScript)";

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
          nodejs_22
          nodePackages.pnpm
          nodePackages.typescript
          nodePackages.typescript-language-server
          nodePackages.prettier
          nodePackages.eslint
        ];

        shellHook = ''
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo "🌐 Web Development Environment"
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo "Node.js: $(node --version)"
          echo "pnpm:    $(pnpm --version)"
          echo ""
          echo "Quick commands:"
          echo "  dev   → pnpm run dev"
          echo "  build → pnpm run build"
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          
          alias dev="pnpm run dev"
          alias build="pnpm run build"
        '';
      };
    };
}
