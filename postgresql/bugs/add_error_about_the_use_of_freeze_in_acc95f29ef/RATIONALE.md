# Rationale

All changes are in `src/backend/commands/copy.c`, function `ProcessCopyOptions()`.

1. **Removed the "Check freeze" block** (`opts_out->freeze && !is_from` -> ERROR
   "COPY FREEZE cannot be used with COPY TO").
   Traces to the last hunk of fix.patch (`@@ -698,46 +698,52 @@`, the `+ /* Check freeze */` lines).
   This is the bug itself: `COPY ... TO ... (FREEZE)` is accepted again without
   any error, and FREEZE is silently ignored.

2. **Restored the old force_quote / force_not_null / force_null error messages**
   ("COPY force quote available only in CSV mode", "COPY force quote only available
   using COPY TO", "COPY force not null available only in CSV mode", "COPY force not
   null only available using COPY FROM", "COPY force null available only in CSV mode",
   "COPY force null only available using COPY FROM"). The two "only available using
   COPY FROM" errors also go back to ERRCODE_FEATURE_NOT_SUPPORTED.
   Traces to the same fix.patch hunk (`@@ -698,46 +698,52 @@`), which reworded these
   messages and changed those errcodes in the same commit. Today the messages use
   translatable `%s` forms, so I rewrote them as the old literal strings that the fix
   replaced. Checking these options is how the fix made "cannot be used with COPY TO/FROM"
   errors consistent across options, and the regression test checks that wording.

I left the QUOTE/ESCAPE message rewordings and the NULL-specification errcode
changes alone to keep the change minimal.

## Failing oracle cases

- `src/test/regress||copy2`: the expected output has "COPY FORCE_QUOTE requires CSV mode",
  "... cannot be used with COPY FROM/TO" and so on, but the old messages come out instead.
  copy2 has no `COPY TO ... FREEZE` test, so change 1 alone makes nothing fail.


<!-- produced on retry with opus -->
