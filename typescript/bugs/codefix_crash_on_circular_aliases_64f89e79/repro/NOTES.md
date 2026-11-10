Input: an ambient module "mymod" in types.d.ts that imports its own default and re-exports it (circular default alias), plus index.ts containing the unresolved identifier `my`.
run.js asks the language service for code fixes (error 2304) at that identifier.
Clean: returns normally (empty fix list). Injected: forEachNameOfDefaultExport has no cycle guard, so it loops until a RangeError (stack overflow) and the script prints "fix crash RangeError".
