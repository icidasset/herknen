let

  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};

in

  pkgs.mkShell {
    buildInputs = [

      # Dev Tools
      pkgs.just
      pkgs.mustache-go

      # Language Specific
      pkgs.elmPackages.elm
      pkgs.elmPackages.elm-format
      pkgs.nodePackages.pnpm

    ];
  }
