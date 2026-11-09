Language-service code fix for the undefined name `variants` in main.js (module node18, allowJs/checkJs, no package.json so files are CommonJS); matrix.js has `exports.variants`, other.js uses ESM syntax.
Clean build offers `const { variants }=require("./matrix")`; injected build (nodenext rule removed from shouldUseRequire) offers `import { variants } from "./matrix"`.
