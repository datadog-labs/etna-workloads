Object.defineProperty(process, "platform", { value: "darwin" });
const fs = require("fs");
const ts = require(process.env.TYPESCRIPT);
fs.writeFileSync("a.ts", "export {}\n");
const st = fs.statSync("a.ts");
const events = [];
const w = ts.sys.watchFile(require("path").resolve("a.ts"), (f, k) => events.push(k), 250, { watchFile: ts.WatchFileKind.UseFsEvents });
setTimeout(() => {
  fs.utimesSync("a.ts", st.atimeMs / 1000 + 5, st.mtime); // atime-only change
  setTimeout(() => {
    console.log("after atime-only touch:", JSON.stringify(events));
    w.close();
    process.exit(0);
  }, 1000);
}, 500);
