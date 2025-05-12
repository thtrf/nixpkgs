#!@GJS@ -m

import { exit, programArgs } from "system";
import { setConsoleLogDomain } from "console";
import Xdp from "gi://Xdp";

// eslint-disable-next-line no-restricted-globals
imports.package.init({
  name: "@app_id@",
  version: "@version@",
  prefix: "@prefix@",
  libdir: "@libdir@",
  datadir: "@datadir@",
});
setConsoleLogDomain(pkg.name);

globalThis.__DEV__ = pkg.name.endsWith(".Devel");
if (__DEV__) {
  pkg.sourcedir = "@sourcedir@";
}

const module = await import("resource:///re/sonny/Workbench/main.js");
const exit_code = await module.main(programArgs);
exit(exit_code);
