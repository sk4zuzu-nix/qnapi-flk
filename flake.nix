{
  description = "A flake for QNapi";

  inputs.nixpkgs.url = "git+file:./nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      with libsForQt5;

      stdenv.mkDerivation rec {
        name = "qnapi_sk4zuzu";
        version = "d4e0378a601838a96b7ee25ff48a8eaf18388fcd";

        src = fetchFromGitHub {
          owner = "QNapi";
          repo = "qnapi";
          rev = version;
          sha256 = "sha256-Epl9/Tw+FfnbnZGczAw1Yt8bjEsnZnxVBSh0rcA/wP4=";
          fetchSubmodules = true;
        };

        dontWrapQtApps = true;

        nativeBuildInputs = [ qmake pkg-config ];

        buildInputs = [ qtbase libmediainfo libzen ];

        configurePhase = ''
          qmake CONFIG+=no_gui
        '';

        installPhase = ''
          strip --strip-unneeded qnapic
          install -d $out/
          install -m+x qnapic $out/qnapic.bin

          cat >$out/qnapic <<EOF
          #!/usr/bin/env bash
          exec $out/qnapic.bin --lang pl --lang-backup en "\$@"
          EOF

          chmod +x $out/qnapic
        '';

        dontFixup = true;
      };
  };
}
