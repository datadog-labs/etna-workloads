Input: a.js has `export default function a() {}`; b.js has `/** @import a, * as ns from "./a" */` (checkJs). The script runs language-service findReferences on `a` in both files.
Clean: returns references in both a.js and b.js.
Injected: findReferences throws "Debug Failure. False expression." (JSDocImportTag isn't handled in getSourceFileLikeForImportDeclaration).
