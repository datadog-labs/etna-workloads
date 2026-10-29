# Rationale

Fix hunk (ext/fts5/fts5_index.c, fts5DoSecureDelete): the page-footer rewrite loop
was changed from a single running `iKeyOff` that is adjusted in place (and
`nShift` zeroed after the first shifted key) to separate input (`iKeyIn`) and
output (`iKeyOut`) offsets.

Reintroduced in `fts5DoSecureDelete` of version-3.54.1 (same loop, now using `nNewPg`):
the loop again accumulates deltas into `iKeyOff`, and when `iKeyOff>iOff` it does
`iKeyOff -= nShift; nShift = 0;`. The shifted value then feeds the next delta
accumulation, so later keys are computed from a corrupted base and written with
wrong deltas. The `iKeyOff>nPg` corruption check added since is kept. Variables
`iPrevKeyOut/iKeyIn` are renamed back to `iPrevKeyOff/iKeyOff` (the old code).

Oracle: `fts5secure-6.0` fails (integrity-check reports corruption after the
secure-delete of rowid 3407, the case added by the fix). Other cases pass.
