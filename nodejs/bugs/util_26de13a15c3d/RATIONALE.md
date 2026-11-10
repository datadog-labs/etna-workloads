# Rationale

Bug: with `util.inspect` `compact` !== true, long strings (longer than breakLength) were split
at whitespace as well as newlines into `'...' +` chunks, instead of only at line breaks.

Hunks (all in lib/internal/util/inspect.js, matching the fix's hunks):
1. Re-added `readableRegExps` cache next to `kMinLineLength` (fix removed it).
2. In `formatPrimitive`, replaced the `split(/(?<=\n)/)` line-based join with the old
   whitespace-aware regex chunking (`(.|\n){1,divisor}(\s|$)|(\n|.)+?(\s|$)`), computing the
   divisor from breakLength/indentation; added imports `MathCeil`, `StringPrototypeMatch`.
   The `trailer` (maxStringLength) handling of today's code is preserved.

Failing: parallel/test-util-inspect, e.g. at line 97 the string with newlines/control chars is
split into a different set of chunks (`'\x1D\n\x03...'` joined instead of `'\x1D\n' +\n '\x03...'`).
