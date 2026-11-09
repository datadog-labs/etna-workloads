const ts=require(process.env.TYPESCRIPT);
const files={"/a.ts":"export namespace A {\n    export function test() {}\n};\n","/b.ts":"import { A } from \"./a\";\n\nA.fn();\n"};
const host={getScriptFileNames:()=>Object.keys(files),getScriptVersion:()=>"1",getScriptSnapshot:f=>files[f]!==undefined?ts.ScriptSnapshot.fromString(files[f]):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({}),getDefaultLibFileName:()=>"/lib.d.ts",fileExists:f=>files[f]!==undefined,readFile:f=>files[f]};
const ls=ts.createLanguageService(host);
const diags=ls.getSemanticDiagnostics("/b.ts");
const fixes=ls.getCodeFixesAtPosition("/b.ts",files["/b.ts"].indexOf("fn"),files["/b.ts"].indexOf("fn")+2,[diags[0].code],{},{});
for(const f of fixes.filter(f=>f.fixName==="fixMissingFunctionDeclaration"))for(const c of f.changes){console.log(c.fileName);for(const t of c.textChanges)console.log(JSON.stringify(t.newText));}
