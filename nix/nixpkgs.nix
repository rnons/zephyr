{ compiler ? "ghc864" }:
with builtins;
let
  rev = "07cf130686d98e05166dfdffe10dcac64379f415";
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  # nix-prefetch-url --unpack
  sha256 = "0mdcznsvzp6x7s6mhqar6vcqh3xhkvarxkq423qxbajmdhzqjg9n";
  # sha256 = "16myhp7vh3lahwr6kdfkgnc3aj5vlw48v2v0la5624n2hsi7wx2y";

  config =
    { packageOverrides = super:
      let self = super.pkgs;
          lib = super.haskell.lib;
      in {
        haskell = super.haskell // {
          packages = super.haskell.packages // {
            ${compiler} = super.haskell.packages.${compiler}.override {
              overrides = self: super: {
                # spdx = lib.dontCheck (super.callPackage ./spdx.nix {});
                purescript = super.callPackage ./purescript.nix {};
              };
            };
          };
        };
      };
    };
  nixpkgs = import (fetchTarball { inherit url sha256; }) { inherit config; };
in nixpkgs
