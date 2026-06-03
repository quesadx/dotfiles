{
  description = "Java template: Maven + JavaFX";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          jdk = pkgs.jdk21.override { enableJavaFX = true; };
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              jdk
              maven
              javaPackages.openjfx21
            ];

            shellHook = ''
              export JAVA_HOME="${jdk}"
            '';
          };
        });
    };
}
