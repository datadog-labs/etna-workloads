# Rationale
fix.diff has one hunk: program.ts `isSourceFileDefaultLibrary` (old code) changed `if (!options.noLib) return false;` to `if (options.noLib) return false;`.
Today's `isSourceFileDefaultLibrary` is `return libFiles.has(file.path)` (libFiles is only populated when !noLib), so the old check no longer exists.
Re-expressed: added `if (!options.noLib) { return false; }` at the top of `isSourceFileDefaultLibrary` in tree/src/compiler/program.ts, i.e. the inverted noLib condition, so default lib files are not recognised as such unless noLib is set.
Result: the tsc/tsbuild/tscWatch libraryResolution baselines and others fail.

SUMMARY: 13/66 oracle cases failing (0 fix-added).
