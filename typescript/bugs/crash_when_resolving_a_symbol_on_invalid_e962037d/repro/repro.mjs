import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const src = `class Foo {
  #prop: string = "";
  method() {
    const test: Foo.#prop = "";
  }
}
`;
const files = { "input.ts": src };
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => ({ target: ts.ScriptTarget.ESNext }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
try {
  const qi = ls.getQuickInfoAtPosition("input.ts", src.lastIndexOf("#prop") + 5);
  console.log(JSON.stringify(qi && qi.displayParts?.map(p => p.text).join("")));
} catch (e) { console.log("crash:", e.message.split("\n")[0]); }
