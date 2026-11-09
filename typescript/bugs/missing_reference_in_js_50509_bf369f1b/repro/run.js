const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("a.js", "utf8");
const host = {
  getScriptFileNames: () => ["/a.js", "/lib.d.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "/lib.d.ts" ? ts.ScriptSnapshot.fromString("interface ThisType<T> {}\ninterface Array<T> {}\ninterface Boolean {}\ninterface Function {}\ninterface IArguments {}\ninterface Number {}\ninterface Object {}\ninterface RegExp {}\ninterface String {}") : f === "/a.js" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ allowJs: true, noImplicitThis: true }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "/a.js" || f === "/lib.d.ts", readFile: f => f === "/a.js" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.lastIndexOf("this.x") + 5;
const res = ls.findReferences("/a.js", pos) || [];
for (const r of res) for (const ref of r.references)
  console.log(ref.isWriteAccess, JSON.stringify(text.substr(ref.textSpan.start - 5, 7)), ref.textSpan.start);
