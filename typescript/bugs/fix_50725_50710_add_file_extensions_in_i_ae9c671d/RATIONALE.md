# Rationale
Hunk: src/compiler/moduleSpecifiers.ts, tryGetModuleNameFromRootDirs. Corresponds to the first hunk of fix.diff
(the only one in moduleSpecifiers.ts). Before the fix, only NodeJs (now Node10) resolution used the ending
preferences (processEnding); all other modes stripped the extension. I restored that: `=== Node10 ? processEnding(...) : removeFileExtension(shortest)`.
With node16/bundler resolution and rootDirs, `./vip.js` becomes `./vip`.

The moveToNewFile.ts hunks were not re-injected: that code now lives in moveToFile.ts and already routes through getModuleSpecifier; reverting would be inventing a different change.

Final check.sh: SUMMARY: 1/2 oracle cases failing (1 fix-added).
