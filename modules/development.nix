{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    python3
    nodejs_22
    jdk21
    go
    gh
    just
  ];
}
