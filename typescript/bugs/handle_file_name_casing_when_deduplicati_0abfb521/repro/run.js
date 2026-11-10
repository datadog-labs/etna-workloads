const ts = require(process.env.TYPESCRIPT);
const files = new Map();
const links = new Map();
const put = (p, c) => files.set(p.toLowerCase(), { p, c });
put("/T/project1/index.ts", "export function myFunc() {\n}");
put("/T/project1/tsconfig.json", JSON.stringify({ compilerOptions: { composite: true } }));
put("/T/project1/package.json", JSON.stringify({ name: "project1", main: "index.js" }));
put("/T/project2/index.ts", "import { myFunc } from 'project1'\nmyFunc();");
put("/T/project2/tsconfig.json", JSON.stringify({ compilerOptions: { composite: true }, references: [{ path: "../project1" }] }));
put("/T/tsconfig.json", JSON.stringify({ references: [{ path: "./project1" }, { path: "./project2" }], files: [], include: [] }));
links.set("/t/node_modules/project1", "/t/project1");
const key = p => p.toLowerCase().replace(/\/+$/, "");
const dirs = () => { const s = new Set(["/", "/t", "/t/node_modules"]); for (const { p } of files.values()) { let d = p; while ((d = d.slice(0, d.lastIndexOf("/"))) ) s.add(key(d)); } return s; };
const resolveLink = p => { const k = key(p); for (const [l, t] of links) if (k === l || k.startsWith(l + "/")) return t + k.slice(l.length); return p; };
const host = {
  args: [], newLine: "\n", useCaseSensitiveFileNames: false,
  write() {}, writeOutputIsTTY: () => false,
  readFile: p => { const f = files.get(key(resolveLink(p))); return f && f.c; },
  writeFile() {}, resolvePath: p => p, fileExists: p => files.has(key(resolveLink(p))),
  directoryExists: p => dirs().has(key(resolveLink(p))) || links.has(key(p)),
  createDirectory() {}, getExecutingFilePath: () => "/tsc.js", getCurrentDirectory: () => "/t",
  getDirectories: p => [], readDirectory: (p) => [...files.values()].map(f => f.p).filter(f => key(f).startsWith(key(p) + "/") && /\.tsx?$/.test(f)), exit() {}, setTimeout, clearTimeout,
  realpath: p => { const r = resolveLink(p); const f = files.get(key(r)); return f ? f.p : p; },
  getModifiedTime: () => undefined, watchFile: () => ({ close() {} }), watchDirectory: () => ({ close() {} }),
  createHash: s => s, getEnvironmentVariable: () => "",
};
const logger = { close() {}, hasLevel: () => false, loggingEnabled: () => false, perftrc() {}, info() {}, startGroup() {}, endGroup() {}, msg() {}, getLogFileName: () => undefined };
let out;
const session = new ts.server.Session({ host, cancellationToken: ts.server.nullCancellationToken, useSingleInferredProject: false, useInferredProjectPerProjectRoot: false, typingsInstaller: ts.server.nullTypingsInstaller, byteLength: Buffer.byteLength, hrtime: () => [0, 0], logger, canUseEvents: false });
session.send = m => { if (m.type === "response") out = m; };
let seq = 0;
const req = (command, args) => { session.onMessage(JSON.stringify({ seq: ++seq, type: "request", command, arguments: args })); return out; };
req("open", { file: "/T/project1/index.ts".toLowerCase() });
const r = req("rename", { file: "/T/project1/index.ts", line: 1, offset: 17 });
if (!r.success) console.log("fail", r.message);
else for (const l of r.body.locs) console.log(l.file, l.locs.map(x => x.start.line + ":" + x.start.offset).join(","));
