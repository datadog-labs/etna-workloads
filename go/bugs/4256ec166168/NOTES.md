repro.go: contains struct literals with key:value elements that trigger type-check errors reported at a KeyValueExpr
(`T{1, b: 2}` mixture error, and a duplicate field name error). types2 reports these at syntax.StartPos(kv).
With the bug, StartPos of a KeyValueExpr returns the position of the ':' rather than the start of the key, so the
reported columns differ (clean 6:11 / 10:28, buggy 6:12 / 10:29). Compile fails on both; only the diagnostics differ.
