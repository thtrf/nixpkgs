{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tui-logger";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "gin66";
    repo = "tui-logger";
    rev = "refs/tags/v${version}";
    hash = "sha256-jrv/fXqafi1lJaxTWreTzc4fSRmbQuVk4ghIZBE04Jk=";
  };

  cargoHash = "";

  meta = {
    description = "Logger with smart widget for the tui and ratatui crates";
    homepage = "https://github.com/gin66/tui-logger";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thtrf ];
    #mainProgram = "";
  };
}
