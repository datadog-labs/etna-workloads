# Rationale

File: src/backend/access/nbtree/nbtutils.c, function `_bt_check_rowcompare`.

Traces to the single implementation hunk of fix.patch (the `cmpresult = 0; continue;` path for a truncated high-key attribute). In current code that path is the `subkey->sk_attno > tupnatts` branch, which now does `return true`. I replaced the `return true` with `cmpresult = 0; continue;`, which does not advance `subkey` and does not stop at `SK_ROW_END`. This is the original pre-fix behavior. When a row compare subkey meets a truncated attribute in a pivot/high key, the loop re-examines the same subkey forever (infinite loop).

Oracle case expected to fail (hang/timeout): src/test/regress||index_including
