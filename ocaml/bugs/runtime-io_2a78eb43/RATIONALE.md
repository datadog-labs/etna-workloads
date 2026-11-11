# Rationale
fix.diff is mostly cosmetic (hunk `@@ -247,7 +247,7 @@ ... static int flush_partial` -> bool). The only runtime-relevant
bug in this area is "close during flush", so I re-expressed the bug in runtime/io.c `flush_partial`:
- return type changed back to `int` (reverses hunk `-static int flush_partial(...)` / `+static bool flush_partial(...)`; no behaviour change).
- moved the `again:` label below `check_pending` and the closed-channel check, so after an EINTR retry
  (where a signal handler may have closed the channel) the closed state is not rechecked and write is
  retried on fd -1. This is the close-during-flush bug that the fix's test (close_during_flush.ml, changed by hunk
  `@@ -1,4 +1,5 @@`) covers. The `continue` hunk in caml_ml_flush is cosmetic and left as is.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` ->
tests/lib-channels/close_during_flush.ml fails (run action, killed).
