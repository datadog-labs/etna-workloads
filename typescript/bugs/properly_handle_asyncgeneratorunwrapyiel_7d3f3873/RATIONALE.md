# Rationale
One hunk, in `tree/src/compiler/factory/emitHelpers.ts` (`asyncGeneratorHelper` text), matching the single hunk of fix.diff.
The fix added `awaitReturn` and `verb(n, f)`, so `return` is wrapped with `Promise.resolve(v).then(f, reject)`. That wrapping is how AsyncGeneratorUnwrapYieldResumption awaits the value passed to `return()`. I removed it. `verb("return")` now takes no wrapper, `verb` is back to its pre-fix form, and `awaitReturn` is gone. The newer `Object.create(AsyncIterator.prototype)` line is untouched.
Final: SUMMARY: 30/210 oracle cases failing (0 fix-added)
