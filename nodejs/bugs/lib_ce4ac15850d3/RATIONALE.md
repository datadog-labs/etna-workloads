# Rationale

**Bug:** `fs.readFile` (callback form) read `options.flags` instead of `options.flag`, so a user-supplied `flag` (e.g. `'a+'`, `'ax+'`) was ignored and the default open flag was used (`undefined` -> 'r').

**Hunk:** `lib/fs.js` in `readFile`: `stringToFlags(options.flag, 'options.flag')` -> `stringToFlags(options.flags, 'options.flag')`. Corresponds to the single fix hunk (`options.flags` -> `options.flag`), re-expressed for today's code, which also passes a name argument.

**Failing test:** `parallel/test-fs-readfile-flags` ("not ok", stable across two runs): with `a+`/`ax+` ignored, the file is not created / no EEXIST is returned, so the assertions fail.
