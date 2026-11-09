import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const cache = new Map();
const host = { ...ts.sys, useCaseSensitiveFileNames: true, onUnRecoverableConfigFileDiagnostic(d){ console.log(d.messageText); } };
for (const f of ["a.json","b.json"]) {
  const p = ts.getParsedCommandLineOfConfigFile(f, undefined, host, cache);
  console.log(f, JSON.stringify(p.watchOptions));
}
