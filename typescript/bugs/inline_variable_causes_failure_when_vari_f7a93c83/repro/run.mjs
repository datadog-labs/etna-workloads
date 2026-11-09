import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `export function Component(props: any) {
    const { foo } = props;
}
`;
const pos = text.indexOf("props;");
const host = {
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.ts",
  readFile: f => f === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const r = ls.getApplicableRefactors("a.ts", { pos, end: pos + 5 }, { allowTextChangesInNewFiles: true });
console.log(r.map(x => x.name + ": " + x.actions.map(a => a.name).join(",")).join("\n"));
