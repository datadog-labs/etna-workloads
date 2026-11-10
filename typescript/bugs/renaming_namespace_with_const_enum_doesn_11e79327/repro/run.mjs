import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const src = `namespace NS {
    export const enum E {
        A = 'a'
    }
}

const a: NS.E = NS.E.A;
`;
const host = {
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(src) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.ts",
  readFile: f => f === "a.ts" ? src : undefined,
};
const ls = ts.createLanguageService(host);
const pos = src.indexOf("NS");
const locs = ls.findRenameLocations("a.ts", pos, false, false) || [];
console.log(locs.map(l => src.slice(l.textSpan.start, l.textSpan.start + l.textSpan.length) + "@" + l.textSpan.start).join("\n"));
