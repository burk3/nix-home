{ ... }: {
  programs.zsh.profileExtra = ''
    source $HOME/.nix-profile/etc/profile.d/nix.sh
  '';

  programs.bash.profileExtra = ''
    source $HOME/.nix-profile/etc/profile.d/nix.sh
  '';
}
