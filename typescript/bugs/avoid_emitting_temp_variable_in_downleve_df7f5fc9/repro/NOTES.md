Input: a TS file with `import(f())` (non-inlineable specifier), compiled with `--module commonjs --target es2017`.
Clean: emits `Promise.resolve(`${f()}`).then(s => __importStar(require(s)))`.
Injected: hoists a temp variable (`var _a;`) and emits `(_a = f(), Promise.resolve().then(() => __importStar(require(_a))))`.
