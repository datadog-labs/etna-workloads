const ts = require(process.env.TYPESCRIPT);
const files = {
"/node.ts": `import Container from "./container.js";
import Document from "./document.js";
declare namespace Node { class Node extends Node_ {} export { Node as default }; }
declare abstract class Node_ { parent: Container | Document | undefined; }
declare class Node extends Node_ {}
export = Node;`,
"/document.ts": `import Container from "./container.js";
declare namespace Document { export { Document_ as default }; }
declare class Document_ extends Container {}
declare class Document extends Document_ {}
export = Document;`,
"/container.ts": `import Node from "./node.js";
declare namespace Container { export { Container_ as default }; }
declare abstract class Container_ extends Node {
  p
}
declare class Container extends Container_ {}
export = Container;`,
};
const opts = { strict: true, module: ts.ModuleKind.CommonJS, esModuleInterop: false, allowSyntheticDefaultImports: false };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const pos = files["/container.ts"].indexOf("p\n") + 1;
const prefs = { includeCompletionsWithInsertText: true, includeCompletionsWithClassMemberSnippets: true };
const c = ls.getCompletionsAtPosition("/container.ts", pos, prefs);
const e = c.entries.find(x => x.name === "parent");
console.log(e && e.insertText);
const d = ls.getCompletionEntryDetails("/container.ts", pos, "parent", {}, e.source, prefs, e.data);
console.log(JSON.stringify(d.codeActions, null, 1));
