import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = `declare function test<T>(a: {
  [K in keyof T]: {
    b?: keyof T;
  };
}): void;
test({
  foo: {},
  bar: {
    b: "",
  },
});
`;
const opts = { target: 99 };
const host = {
  getScriptFileNames: () => ["a.tsx"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.tsx" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "a.tsx", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf('b: ""') + 4;
const r = ls.getCompletionsAtPosition("a.tsx", pos, {});
console.log(JSON.stringify(r && r.entries.map(e => e.name).sort()));
