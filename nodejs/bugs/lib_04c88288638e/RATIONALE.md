# lib: fix TypeScript support check in jitless mode

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 04c88288638e6eb96ec4ac4977eade83a56b50c4 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
lib: fix TypeScript support check in jitless mode

WebAssembly is disabled when Node.js is run with --jitless. The
internal TypeScript stripper relies on WebAssembly, and previously
failed obscurely with a ReferenceError in this mode.

This commit adds an explicit check for WebAssembly support when
loading the TypeScript parser. If WebAssembly is unavailable,
it now throws a descriptive ERR_WEBASSEMBLY_NOT_SUPPORTED error.

Fixes: https://github.com/nodejs/node/issues/61353
PR-URL: https://github.com/nodejs/node/pull/61382
Reviewed-By: Marco Ippolito <marcoippolito54@gmail.com>
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
```
