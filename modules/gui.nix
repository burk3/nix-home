{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    vscode.fhs
    bitwarden-desktop
    yacreader
    legcord
    mpv
    spotify
    playerctl
    kitty
    rio
    foot
  ];
  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };

  # set ssh-agent to use the gnome-keyring socket
  home.sessionVariables = {
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR:-/run/user/$UID}/keyring/ssh";
  };
}
