# Rationale

Bug: the AOF manifest only quoted file names containing whitespace, with raw
quotes and no escaping, so names with newlines etc. broke the manifest.

Changes (all reverse hunks of fix.patch):
- `src/aof.c` `aofInfoFormat`: reverses the hunk that switched to
  `sdsneedsrepr()` + `sdscatrepr()`. Restored the pre-fix `includeSpace()`
  check that wraps the name in plain `"..."` without escaping.
  (`sdsneedsrepr` in sds.c is left in place, now unused.)
- `src/util.c` / `src/util.h`: reverses the hunks removing `includeSpace()`;
  re-added it verbatim.

I did not restore the `appenddirname` whitespace check in config.c (it is a
separate limitation relaxation and not needed for the bug).

Failing oracle case: "Multi Part AOF can handle appendfilename contains
whitespaces" — the filename contains `\n\n`, so the manifest has 6 lines
instead of 2 (`Expected '6' to be equal to '2'`). The other 36 cases pass.
