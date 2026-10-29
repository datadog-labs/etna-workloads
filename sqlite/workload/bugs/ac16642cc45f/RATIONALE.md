# Rationale

Fix hunk (ext/qrf/qrf.c, qrfFinalize): wrapped the closing text of styles
"json" (`}]\n`) and "jobject" (`}\n`) in `if( p->nRow>0 )`.

In 3.54.1 the same guards exist in `qrfFinalize` (ext/qrf/qrf.c, ~line 3047)
without the `qrfWrite()` calls. I removed both `if( p->nRow>0 )` guards, so the
closing text is again appended unconditionally, which is the pre-fix behaviour.

Oracle failures: qrf01-9.3 and qrf01-9.4. An empty result set with
`-style json` / `-style jobject` now outputs `}]\n` / `}\n` instead of an empty string.
