{
  description = "Home Manager configuration of burke";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    #home-manager = {
    #  url = "github:nix-community/home-manager/release-24.11";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    { catppuccin, ... }:
    {
      homeManagerModules = rec {
        home = { ... }: { imports = [
          catppuccin.homeManagerModules.catppuccin
          ./home.nix
          ./modules/shell.nix
        ]; };
        gui = { ... }: { imports = [ home ./modules/gui.nix ]; };
        hypr = { ... }: { imports = [ gui ./modules/hypr.nix ]; };
        single-user = ./modules/single-user.nix;
      };
    };
}
