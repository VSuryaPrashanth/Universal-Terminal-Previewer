{
  description = "A simple terminal previewer";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.ca = pkgs.writeTextFile {
          name = "ca";
          executable = true;
          destination = "/bin/ca";
          text =
            let
              binPath = pkgs.lib.makeBinPath [
                pkgs.moreutils
                pkgs.coreutils
                pkgs.mpv
                pkgs.timg
                pkgs.jq
                pkgs.bat
                pkgs.eza
                # TODO: Add awrit, euporie
                pkgs.nvimpager
                pkgs.python312Packages.pyexcel
                # pkgs.libreoffice
                pkgs.fontforge
                pkgs.gnupg
                pkgs.atool
                pkgs.transmission_4
                pkgs.exiftool
              ];
            in ''
              #!${pkgs.runtimeShell}
              export PATH="${binPath}:$PATH"
            '' + builtins.readFile ./utp.zsh;
        };
      }
    );
}
