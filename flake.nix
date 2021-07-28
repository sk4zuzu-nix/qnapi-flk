{
  description = "A flake for QNapi";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-21.05;

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      with libsForQt5;

      stdenv.mkDerivation rec {
        name = "qnapi_sk4zuzu";
        version = "2c95060fccf9422301d756d7e80fb2fc154ccb13";

        src = fetchFromGitHub {
          owner = "QNapi";
          repo = "qnapi";
          rev = version;
          sha256 = "sha256-zHX7XQ6JalqGVy4g68Ln0DRJR9JwaUTEQJrQ63+kVqo=";
          fetchSubmodules = true;
        };

        dontWrapQtApps = true;

        nativeBuildInputs = [ qmake pkgconfig ];

        buildInputs = [ qtbase libmediainfo libzen ];

        configurePhase = ''
          qmake CONFIG+=no_gui
        '';

        installPhase = ''
          strip --strip-unneeded qnapic
          install -d $out/
          install -m+x qnapic $out/qnapic
        '';
      };
  };
}
