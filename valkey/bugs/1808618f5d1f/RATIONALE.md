# Rationale

## src/listpack.c, lpValidateIntegrity
Reverses the single implementation hunk of the fix: removes the post-loop check
`if (p != lp + size - 1) return 0;`. The function is structurally unchanged in 9.0.7
(same loop `while (p && p[0] != LP_EOF)`), so deleting the check restores the pre-fix
behaviour: an entry that starts with an EOF byte (0xff) ends the loop early, and the
listpack is accepted even though `p` isn't at the real terminator.

## Oracle failure
`corrupt payload: quicklist listpack entry start with EOF` fails: RESTORE with
sanitize-dump-payload yes returns OK instead of "Bad data format". The other 88 cases pass.
