import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/generation.d.ts": `export type GenerationConfigType = { max_length?: number };`,
  "/index.d.ts": `export declare class PreTrainedModel {
  _get_generation_config(
    param: import("./generation.js").GenerationConfigType,
  ): import("./generation.js").GenerationConfigType;
}

export declare class Sub extends PreTrainedModel {
  
}
`,
};
const opts = { module: ts.ModuleKind.Node18, target: ts.ScriptTarget.ES2022 };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const pos = files["/index.d.ts"].indexOf("{\n  \n}") + 4;
try {
  const c = ls.getCompletionsAtPosition("/index.d.ts", pos, {
    includeCompletionsWithClassMemberSnippets: true,
    includeCompletionsWithInsertText: true,
  });
  console.log(JSON.stringify(c.entries.filter(e => e.name === "_get_generation_config").map(e => e.insertText)));
} catch (e) { console.log("crash:", e.message.split("\n")[0]); }
