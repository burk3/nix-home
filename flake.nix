{
  description = "Home Manager configuration of burke";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."burke" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules =
          let
            flags = builtins.readDir ./flags;
            common = [
              ./home.nix
              ./shell.nix
            ];
            gui = [
              ./gui.nix
              ./hypr.nix
            ];
          in
          if flags ? "GUI" then common ++ gui else common;

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
