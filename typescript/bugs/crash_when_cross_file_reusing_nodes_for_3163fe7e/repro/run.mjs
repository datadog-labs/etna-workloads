import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
"/KlassConstructor.ts": `type GenericConstructor<T> = new (...args: any[]) => T;
export type KlassConstructor<Cls extends GenericConstructor<any>> =
  GenericConstructor<InstanceType<Cls>> & { [k in keyof Cls]: Cls[k] };
`,
"/ElementNode.ts": `import { KlassConstructor } from "./KlassConstructor";
export type NodeKey = string;
export class ElementNode {
  ["constructor"]!: KlassConstructor<typeof ElementNode>;
}
`,
"/C.ts": `import { ElementNode, NodeKey } from "./ElementNode";
export class CollapsibleContainerNode extends ElementNode {
  __open: boolean;

  
}
`};
const opts = { strict: true, target: ts.ScriptTarget.ES2022 };
const host = {
  getCompilationSettings: () => opts,
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const pos = files["/C.ts"].indexOf("\n  \n") + 3;
try {
  const r = ls.getCompletionsAtPosition("/C.ts", pos, { includeCompletionsWithClassMemberSnippets: true, includeCompletionsWithInsertText: true });
  console.log(JSON.stringify(r.entries.filter(e => e.source === "ClassMemberSnippet/").map(e => [e.name, e.insertText])));
} catch (e) { console.log("ERR", e.message); }
