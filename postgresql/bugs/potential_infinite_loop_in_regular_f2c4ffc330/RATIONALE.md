# Rationale
- File/function: src/backend/regex/regexec.c, cfindloop()
- Traces to fix_impl.patch hunk adding `close++;` before `} while (close < v->stop);`.
- Removing it means that when no match starts between open and close, the next
  iteration re-runs shortest() from the same `close`, finding the same range again: an infinite loop.

Failing oracle case: src/test/regress||regex (hangs/times out).
