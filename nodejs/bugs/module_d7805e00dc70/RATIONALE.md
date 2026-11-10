# module: fix --check on ambiguous ESM files

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit d7805e00dc7043f439e943ca5132244751fa3ba9 applied to v26.13.0 (clean).

Upstream commit message:

```
module: fix --check on ambiguous ESM files

A `.js` file with no `"type"` in the nearest package.json has no format
of its own, and `defaultGetFormat()` reports it as null. `--check`
passed that null straight to `wrapSafe()`, which parses as CommonJS.
Module syntax makes that parse bail out early, so the file was reported
as valid and `--check` exited 0 even though it is not valid JavaScript
under either goal.

At load time the goal for such a file is decided by looking for module
syntax in the source. Decide it the same way here, so the file is
parsed as a module and its real syntax error is reported. Files whose
format is known are unaffected, as are ambiguous files without module
syntax, which are still parsed as CommonJS.

Fixes: https://github.com/nodejs/node/issues/65202
Signed-off-by: Paul Bouchon <mail@bitpshr.net>
PR-URL: https://github.com/nodejs/node/pull/65203
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
```
