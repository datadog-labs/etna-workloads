repro.sql: fts4 table with one long row containing a single 'E' among 'x' tokens; calls snippet(t4,'','','',0,150).
Without the nToken clamp to ±64, the buggy shell hits an assertion in fts3SnippetShift (undefined 64-bit shift) and aborts (exit -6); the clean shell prints 127.
