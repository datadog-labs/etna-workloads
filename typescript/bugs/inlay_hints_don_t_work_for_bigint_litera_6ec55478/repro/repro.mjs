import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `const a1: '"' = '"';
export function fn(a = a1) {}
`;
const host = {
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ strict: true }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.ts",
  readFile: f => f === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const hints = ls.provideInlayHints("a.ts", { start: 0, length: text.length }, {
  includeInlayFunctionParameterTypeHints: true,
  interactiveInlayHints: true,
});
for (const h of hints) console.log(JSON.stringify(h.displayParts));
