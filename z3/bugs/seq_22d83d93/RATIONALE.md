Changed hunk: src/ast/rewriter/seq_rewriter.cpp, seq_rewriter::mk_seq_reverse.
Traces to the seq_rewriter.cpp hunk of FIX.diff: removes the `zstring::reverse` handling of string
literals and the `return false` for non-concrete elements; every non-concat element is kept whole
and the function always returns true (old behaviour: rev("abc")="abc", rev(x)=x).
The bool signature and the seq_monadic.cpp/header hunks are kept, since the unchangeable test
needs the bool signature; the seq_monadic hunk is just the propagation of failure (now never taken).
Result: seq_rewriter unit FAILS at "result == cba_str" (see ./check.sh output: FAIL seq_rewriter).
FAIL seq_rewriter (rc=114)
