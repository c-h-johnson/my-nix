{ pkgs, ... }:

{
  users.users.charles = {
    extraGroups = [ "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    virt-manager
  ];

  # virt-manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
}
