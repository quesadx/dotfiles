{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.hermes-agent.packages.${pkgs.system}.default
  ];

  system.activationScripts.hermes-agent.text = ''
    mkdir -p /var/lib/hermes
  '';
}
