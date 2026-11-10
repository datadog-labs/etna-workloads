import type pkgRequire from "pkg" with { "resolution-mode": "require" };
import type pkgImport from "pkg" with { "resolution-mode": "import" };
export const a: typeof pkgRequire = "cjs";
export const b: typeof pkgImport = "esm";
