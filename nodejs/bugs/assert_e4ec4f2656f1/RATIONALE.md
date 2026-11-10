# Re-introduced bug: identical line printed twice in assert diff

**Bug.** In the error diff, in some edge cases an identical (unchanged) line was printed twice, because the code
mis-tracked how many identical lines preceded the current one. The upstream fix (e4ec4f2656f1) replaced the
`lastPos`/`cur` bookkeeping in `createErrDiff` with an `identical` counter.

**Today's code.** `createErrDiff` was replaced by a Myers diff (`lib/internal/assert/myers_diff.js`), so the old
hunks can't be reversed literally. The equivalent logic is the NOP-run counter (`nopCount`) in `printMyersDiff`.

**Change (one hunk, `lib/internal/assert/myers_diff.js`).** `nopCount < kNopLinesToCollapse` became
`nopCount <= kNopLinesToCollapse`. This corresponds to the fix's hunks that changed how many identical lines
are counted and printed before a diverging line. One extra identical line is now printed eagerly, and the
collapse branches (`kNopLinesToCollapse + 1`, `+ 2`, `+ 3`) then print that same line again, so a line
appears twice. The fix's other hunks (`breakLength`, `hasColors`) have no counterpart that matters here.

**Failing test.** `parallel/test-assert-deep` fails ("not ok 1") on both runs. The expected diff message no
longer matches, because of the duplicated identical line. I did not capture the full failure text.
