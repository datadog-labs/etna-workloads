Reproducer: traceback caret anchors for `(x + 1) / 0`. The buggy build's
`increment_until` no longer skips `)` when finding the binary operator, so the
`^` marker lands on the `+`-side `)` instead of the `/` operator
(`~~~~~~^~~~~` vs `~~~~~~~~^~~`). Clean and buggy outputs differ in that line.
