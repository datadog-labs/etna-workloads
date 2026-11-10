import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const src = `declare const Foo: (props: {className?: string, onClick?: () => void}) => any;
const a = <Foo something={false} cla />;
const b = <Foo something={false}  foo />;
`;
const host = {
  getScriptFileNames: () => ["file.tsx"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "file.tsx" ? ts.ScriptSnapshot.fromString(src) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({ jsx: ts.JsxEmit.Preserve, strict: true }),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "file.tsx", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
for (const [label, pos] of [["after-cla", src.indexOf("cla") + 3], ["blank", src.indexOf("  foo") + 1]]) {
  const r = ls.getCompletionsAtPosition("file.tsx", pos, { jsxAttributeCompletionStyle: "braces", includeCompletionsWithSnippetText: true, includeCompletionsWithInsertText: true });
  const e = r?.entries.find(x => x.name === "className");
  console.log(label, e ? `${e.insertText} ${e.isSnippet}` : "none");
}
