# Rationale
Hunk 1 of fix.diff (`if (!options.noLib)` -> `if (options.noLib)` in the default-lib check): today's code replaced the
path comparison with a `libFiles` set, but `isSourceFileDefaultLibrary` is the same function. I re-added the buggy
inverted guard `if (!options.noLib) return false;` in `isSourceFileDefaultLibrary` (src/compiler/program.ts), so with libs
enabled no file is reported as a default library (and with noLib it still consults libFiles).
Hunk 2 (null-check on unresolved lib in `some(options.lib...)`) has no counterpart: that code no longer exists
(lib resolutions are always recorded by `pathForLibFile`), so nothing was changed for it.

Final: SUMMARY: 12/16 oracle cases failing (0 fix-added).
