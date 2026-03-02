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
          python314
          python314Packages.pip
          python314Packages.virtualenv
          
          # Common packages
          python314Packages.pytest
          python314Packages.black
          python314Packages.flake8
          
          # LSP
          python312Packages.python-lsp-server
        ];

        shellHook = ''
          echo "Python Development Environment"
          
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
        '';
      };
    };
}
