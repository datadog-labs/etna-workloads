# Re-introduced bug: fs.constants.S_IRUSR / S_IWUSR missing

**Bug.** On Windows the POSIX S_IRUSR/S_IWUSR macros do not exist, so `fs.constants.S_IRUSR`
and `S_IWUSR` were `undefined` (nodejs/node#41591). The fix aliased them to `_S_IREAD`/`_S_IWRITE`.

**Change (src/node_constants.cc).** Reversing the fix hunk only removes a `_WIN32`-only block, which is
a no-op on Linux, so no test failed. To reproduce the pre-fix state on Linux:
- The fix's `#if defined(_WIN32) ... #define S_IRUSR _S_IREAD ... #define S_IWUSR _S_IWRITE` hunk is replaced
  by `#define NODE_NO_USR_RW_ALIASES 1`, which stands for "no aliases are provided".
- The `#ifdef S_IRUSR` / `#ifdef S_IWUSR` guards around `NODE_DEFINE_CONSTANT` in `DefineFsConstants`
  now also require `!defined(NODE_NO_USR_RW_ALIASES)`. Both constants are therefore not exported, as in
  the old Windows behaviour. (This guard edit goes beyond the fix's hunks, and is needed because Linux
  defines the macros natively. `#undef` would break S_IRGRP etc. in glibc.)

**Failing test.** `parallel/test-fs-constants` fails (2 runs, stable):
`AssertionError [ERR_ASSERTION]: Expected "actual" to be strictly unequal to: undefined`
