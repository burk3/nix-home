{
  description = "Home Manager configuration of burke";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    isd.url = "github:isd-project/isd";
  };

  outputs =
    { nixpkgs, home-manager, catppuccin, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."burke" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        # Here I'm using the contents of the `flags` dir to decide what modules to pull in.
        # Hopefully this is not too much of a faux pas. :)
        # Always pull in home and shell.
        modules = let
          local = ./local/default.nix;
          flags = builtins.readDir ./flags;
          single-user = ./modules/single-user.nix;
          gui = ./modules/gui.nix;
          hypr = ./modules/hypr.nix;
        in [
          catppuccin.homeManagerModules.catppuccin
          ./home.nix
          ./modules/shell.nix
        ] ++
            (if flags ? "GUI" then [ gui ] else []) ++
            (if flags ? "SINGLE-USER" then [ single-user ] else []) ++
            (if flags ? "HYPR" then assert flags ? "GUI"; [ hypr ] else []) ++
            (if builtins.pathExists local then [ local ] else []);

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          extraPkgs = {
            isd = inputs.isd.packages.${system}.default;
          };
        };
      };
    };
}
