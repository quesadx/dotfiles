{
  description = "Python Development Environment";

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
          python312
          python312Packages.pip
          python312Packages.virtualenv
          
          # Common packages
          python312Packages.pytest
          python312Packages.black
          python312Packages.flake8
          
          # LSP
          python312Packages.python-lsp-server
        ];

        shellHook = ''
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo "🐍 Python Development Environment"
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo "Python: $(python --version)"
          echo ""
          
          # Create and activate venv
          if [ ! -d .venv ]; then
            echo "Creating virtual environment..."
            python -m venv .venv
          fi
          
          source .venv/bin/activate
          
          # Install from requirements.txt if it exists
          if [ -f requirements.txt ]; then
            echo "Installing dependencies from requirements.txt..."
            pip install -r requirements.txt
          fi
          
          echo ""
          echo "Virtual environment activated!"
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        '';
      };
    };
}
