Parses a Content-Disposition header mixing an unnumbered `filename*` with RFC 2231
continuations `filename*0*`/`filename*1*`, then prints `get_filename()`.
Clean: `'foo bar.txt'`. Buggy: the unnumbered part is not ignored/ordered correctly
(TypeError: sorting None against int), so the output differs.
