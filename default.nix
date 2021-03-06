{ stdenv
, autoPatchelfHook
, unzip
, zlib
, libGLU
, alsaLib
, libpulseaudio
, makeWrapper
, libXi
, libX11
, libXrandr
, libXcursor
, libXinerama
, gnome
, gdb
}:
let
  inherit (stdenv) lib;
  inherit (gnome) zenity;
  name = "dungeondraft";
  version = "1.0.1.1";
  path = lib.makeBinPath [ zenity gdb ];

in
stdenv.mkDerivation rec {
  inherit name version;

  src = ./dungeondraft-1.0.1.3-hotfix.zip;

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  buildInputs = [
    zlib
    libGLU
    alsaLib
    libpulseaudio

    makeWrapper

    stdenv.cc.cc.lib

    libXi
    libX11
    libXrandr
    libXcursor
    libXinerama
  ];

  unpackCmd = "unzip $curSrc -d ./dungeondraft";

  sourceRoot = "dungeondraft";

  installPhase = ''
    name=${name}

    mkdir -p $out/bin
    mkdir -p $out/share/applications

    chmod +x Dungeondraft.x86_64

    substituteInPlace ./Dungeondraft.desktop \
      --replace '/opt/Dungeondraft/Dungeondraft.x86_64' "$out/bin/$name" \
      --replace '/opt/Dungeondraft' $out \
      --replace '/opt/Dungeondraft/Dungeondraft.png' "$out/Dungeondraft.png"

    mv ./Dungeondraft.desktop $out/share/applications/
    mv ./Dungeondraft.x86_64 "$out/$name"
    mv ./Dungeondraft.pck $out/$name.pck

    makeWrapper $out/$name $out/bin/$name \
        --prefix PATH : ${path}

    mv ./* $out
  '';
}
