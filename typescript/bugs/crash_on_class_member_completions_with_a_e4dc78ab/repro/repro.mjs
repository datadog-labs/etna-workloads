import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/node_modules/@types/vscode/index.d.ts": `declare module "vscode" {
  export class Position { readonly line: number; readonly character: number; }
}`,
  "/src/motion.ts": `import { Position } from "vscode";
export abstract class MoveQuoteMatch {
  public override async execActionWithCount(position: Position): Promise<void> {}
}
declare module "vscode" {
  interface Position { toString(): string; }
}`,
  "/src/smartQuotes.ts": `import { MoveQuoteMatch } from "./motion";

export class MoveInsideNextQuote extends MoveQuoteMatch {
  keys = ["i", "n", "q"];
}`,
};
const opts = { strict: true, module: ts.ModuleKind.CommonJS, moduleResolution: ts.ModuleResolutionKind.Node10, target: ts.ScriptTarget.ES2020 };
const host = {
  getCompilationSettings: () => opts,
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
  directoryExists: d => Object.keys(files).some(f => f.startsWith(d.endsWith("/") ? d : d + "/")),
  getDirectories: () => [],
};
const ls = ts.createLanguageService(host);
const file = "/src/smartQuotes.ts";
const pos = files[file].indexOf("{\n  keys") + 1;
const prefs = { includeCompletionsWithInsertText: true, includeCompletionsWithClassMemberSnippets: true };
try {
  const c = ls.getCompletionsAtPosition(file, pos, prefs);
  const e = c.entries.find(e => e.name === "execActionWithCount");
  console.log(JSON.stringify({ insertText: e.insertText, hasAction: e.hasAction, source: e.source }));
  const d = ls.getCompletionEntryDetails(file, pos, "execActionWithCount", {}, e.source, prefs, e.data);
  console.log(d.codeActions?.map(a => a.description));
  for (const a of d.codeActions ?? []) for (const ch of a.changes) for (const t of ch.textChanges) console.log(JSON.stringify(t.newText));
} catch (err) { console.log("ERROR", err.message); }
