{ lib
, fetchFromGitHub
, stdenv
, autoconf
, automake
, libtool
, tre
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "scalpel";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "sleuthkit";
    repo = "scalpel";
    rev = "35e1367";
    hash = "sha256-0lqU1CAcWXNw9WFa29BXla1mvABlzWV+hcozZyfR0oE=";
  };

  nativeBuildInputs = [ autoconf automake libtool tre ];

  postPatch = ''
    sed -i \
      -e 's|#define\s*SCALPEL_DEFAULT_CONFIG_FILE\s.*"scalpel.conf"|#define SCALPEL_DEFAULT_CONFIG_FILE "${placeholder "out"}/share/scalpel/scalpel.conf"|' \
      src/scalpel.h
  '';

  CXXFLAGS = "-std=c++14";

  preConfigure = ''
      ./bootstrap
  '';

  configureFlags = [
    "--with-pic"
    "--prefix=${placeholder "out"}"
  ];

  postInstall = ''
    mkdir -p $out/share/scalpel
    cp scalpel.conf $out/share/scalpel/
  '';

  meta = with lib; {
    homepage = "https://github.com/sleuthkit/scalpel";
    description = "Recover files based on their headers, footers and internal data structures, based on Foremost";
    mainProgram = "scalpel";
    maintainers = with maintainers; [ shard7 ];
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ binaryNativeCode binaryBytecode ];
    license = with licenses; asl20;
  };
})
