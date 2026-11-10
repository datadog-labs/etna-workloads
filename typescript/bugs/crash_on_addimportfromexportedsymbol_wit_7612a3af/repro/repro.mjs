import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
 "/other.ts": "export default class Other {}\n",
 "/base.ts": 'import Other from "./other";\nexport class Base {\n    foo(): Other {\n        throw new Error("");\n    }\n}\n',
 "/derived.ts": 'import { Base } from "./base";\nexport class Derived extends Base {\n    \n}\n',
};
const host = {
 getScriptFileNames: () => Object.keys(files),
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
 getCurrentDirectory: () => "/",
 getCompilationSettings: () => ({ module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2020, moduleResolution: ts.ModuleResolutionKind.Bundler }),
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => files[f] !== undefined,
 readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const pos = files["/derived.ts"].indexOf("    \n") + 4;
const r = ls.getCompletionsAtPosition("/derived.ts", pos, { includeCompletionsWithInsertText: true, includeCompletionsWithClassMemberSnippets: true });
const e = r && r.entries.find(x => x.name === "foo");
console.log(JSON.stringify(e && { insertText: e.insertText, hasAction: e.hasAction, source: e.source }));
if (e) {
  const d = ls.getCompletionEntryDetails("/derived.ts", pos, "foo", {}, e.source, { includeCompletionsWithInsertText: true, includeCompletionsWithClassMemberSnippets: true }, e.data);
  console.log(JSON.stringify(d && d.codeActions));
}
