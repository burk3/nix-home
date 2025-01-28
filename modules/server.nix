{ pkgs, ... }:
{
  home.file.".terminfo" = {
    source = "${pkgs.ghostty}/share/terminfo";
    recursive = true;
  };
}
