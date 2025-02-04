{
  description = "Home Manager configuration modules of burke";

  inputs = {
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    { catppuccin, ... }:
    {
      homeManagerModules = let
          mkMod = mods: { ... }: { imports = mods; };
        in rec {
        home = mkMod [
          catppuccin.homeModules.catppuccin
          ./home.nix
          ./modules/shell.nix
        ];
        server = mkMod [ home ./modules/server.nix ];
        gui = mkMod [ home ./modules/gui.nix ];
        hypr = mkMod [ gui ./modules/hypr.nix ];
        single-user = ./modules/single-user.nix;
        wsl = ./modules/wsl.nix;
      };
    };
}
