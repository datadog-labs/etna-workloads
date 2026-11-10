# readline: fix issue with newline-less last line

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9decb70d05c90a99beed402a4867691f313e2fd9 applied to v26.13.0 (clean).

Upstream commit message:

```
readline: fix issue with newline-less last line

The logic for reading lines was slightly flawed, in that it assumed
there would be a final new line. It handled the case where there are no
new lines, but this then broke if there were some new lines.

The fix in logic is basically removing the special case where there are
no new lines by changing it to always read the final line with no new
lines. This works because if a file contains no new lines, the final
line is the first line, and all is well.

There is some subtlety in this functioning, however. If the last line
contains no new lines, then `lastIndex` will be the start of the last
line, and `kInsertString` will be called from that point. If it does
contain a new line, `lastIndex` will be equal to `s.length`, so the
slice will be the empty string.

Fixes: https://github.com/nodejs/node/issues/47305
PR-URL: https://github.com/nodejs/node/pull/47317
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
