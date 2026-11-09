const ts=require(process.env.TYPESCRIPT);
const files={
"/default.ts":"export default class TestDefaultClass {}",
"/defaultType.ts":"export default interface TestDefaultInterface {}",
"/toReExport.ts":"export class TestClassReExport {}\nexport interface TestInterfaceReExport {}",
"/index.ts":"export { TestClassReExport, TestInterfaceReExport } from './toReExport';",
"/exportList.ts":"class TestClassExportList {};\ninterface TestInterfaceExportList {};\nexport { TestClassExportList, TestInterfaceExportList };",
"/a.js":"import "};
const opts={allowJs:true};
const host={getScriptFileNames:()=>Object.keys(files),getScriptVersion:()=>"1",
getScriptSnapshot:f=>files[f]!==undefined?ts.ScriptSnapshot.fromString(files[f]):undefined,
getCurrentDirectory:()=>"/",getCompilationSettings:()=>opts,getDefaultLibFileName:()=>"/lib.d.ts",
fileExists:f=>f in files,readFile:f=>files[f],directoryExists:()=>true,getDirectories:()=>[]};
const ls=ts.createLanguageService(host);
const r=ls.getCompletionsAtPosition("/a.js",7,{includeCompletionsForImportStatements:true,includeCompletionsWithInsertText:true});
console.log((r?r.entries.filter(e=>e.name.startsWith("Test")).map(e=>e.name+" "+e.source):[]).join("\n"));
