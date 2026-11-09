const ts = require(process.env.TYPESCRIPT);
const text = `class C {
    constructor() {
        this.prop = "";
    }
    declare prop: string;
    method() {
        this.prop.foo
    }
}
`;
const opts = { allowJs: true, checkJs: true, noEmit: true };
const host = ts.createCompilerHost(opts);
const orig = host.getSourceFile;
host.getSourceFile = (f, l) => f === "a.js" ? ts.createSourceFile(f, text, l) : orig(f, l);
host.fileExists = f => f === "a.js" || ts.sys.fileExists(f);
const p = ts.createProgram(["a.js"], opts, host);
const c = p.getTypeChecker();
try {
  for (const d of ts.getPreEmitDiagnostics(p)) console.log(d.code, ts.flattenDiagnosticMessageText(d.messageText, "\n"));
  console.log("done");
} catch (e) { console.log("crash:", String(e.message).split("\n")[0]); }
