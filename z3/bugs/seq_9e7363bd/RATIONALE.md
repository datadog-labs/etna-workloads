Changed hunk: src/src/ast/seq_decl_plugin.cpp, mk_info_rec OP_RE_LOOP.
Traces to the seq_decl_plugin.cpp hunk of FIX.diff: reverted to reading bounds only from decl parameters,
dropping the get_num_args() branch for the argument form. (re.loop r 1 3) then gets lower=0, so it is
reported nullable with min_length 0 (the soundness bug). The seq_derive.cpp hunk was left in place.
Not reproducing the perf half is fine: the soundness bug alone fails the test.

check.sh: seq_rewriter FAILS with
  re.loop arguments: (re.loop (str.to_re "ab") 1 3) nullable=l_true min_length=0
  ASSERTION VIOLATION ... Failed to verify: i2.nullable == l_false && i2.min_length == 2
