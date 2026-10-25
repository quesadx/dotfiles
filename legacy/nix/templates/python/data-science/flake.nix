{
  description = "Python template: Data science";

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
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              python3
              python3Packages.jupyterlab
              python3Packages.numpy
              python3Packages.pandas
              python3Packages.matplotlib
              python3Packages.seaborn
              python3Packages.scikit-learn
            ];
          };
        });
    };
}
