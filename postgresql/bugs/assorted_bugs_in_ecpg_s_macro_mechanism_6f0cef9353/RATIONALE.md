# Rationale

Changed hunk: src/interfaces/ecpg/preproc/pgc.l, `<xcond>`/ifdef-ifndef handling in `yylex` (the "Does a definition exist?" loop).

Traces to the fix.patch pgc.l hunk that makes ifdef/ifndef treat a symbol whose `value == NULL` (undefined via `exec sql undef`, but kept because of a command-line cmdvalue) as not found. I removed that check. Now `ifdef` still sees an undef'd command-line symbol as defined, so it takes the wrong branch. Before the fix, the old code removed the entry or otherwise misreported its state.

Oracle case expected to fail: src/interfaces/ecpg||sql/define
