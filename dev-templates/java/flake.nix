{
  description = "Java Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      jdk = pkgs.jdk21.override { enableJavaFX = true; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          jdk
          maven
          javaPackages.openjfx21
        ];

        shellHook = ''
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo "☕ Java Development Environment"
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo "Java:  $(java -version 2>&1 | head -n1)"
          echo "Maven: $(mvn -v | head -n1)"
          echo ""
          echo "Quick commands:"
          echo "  mci → mvn clean install"
          echo "  mct → mvn clean test"
          echo "  mcp → mvn clean package"
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          
          export JAVA_HOME="${jdk}"
          
          alias mci="mvn clean install"
          alias mct="mvn clean test"
          alias mcp="mvn clean package"
        '';
      };
    };
}
