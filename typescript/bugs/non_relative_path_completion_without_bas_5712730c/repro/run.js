const ts=require(process.env.TYPESCRIPT),fs=require('fs');
const cfg=ts.parseJsonConfigFileContent({compilerOptions:{paths:{'module1/*':['some/path/*']}}},ts.sys,'.');
const cwd=ts.sys.getCurrentDirectory();
const files=['test0.ts','some/path/whatever.ts'];
const host={getScriptFileNames:()=>files,getScriptVersion:()=>'1',getScriptSnapshot:f=>fs.existsSync(f)?ts.ScriptSnapshot.fromString(fs.readFileSync(f,'utf8')):undefined,getCurrentDirectory:()=>cwd,getCompilationSettings:()=>cfg.options,getDefaultLibFileName:ts.getDefaultLibFilePath,fileExists:ts.sys.fileExists,readFile:ts.sys.readFile,readDirectory:ts.sys.readDirectory,directoryExists:ts.sys.directoryExists,getDirectories:ts.sys.getDirectories};
const ls=ts.createLanguageService(host);
const t=fs.readFileSync('test0.ts','utf8');
const r=ls.getCompletionsAtPosition('test0.ts',t.trimEnd().length,{});
console.log(JSON.stringify(r&&r.entries.map(e=>e.name)));
