Changed hunk: src/ast/seq/seq_axioms.cpp (at_axiom). Traces to the first hunk of FIX.diff: removes the 'iv <= 1024' bound so concrete seq.at indices are always expanded element by element, instead of using the symbolic split for large indices. This is the unbounded-expansion bug (huge allocation, no resource polling). seq_limits fails at check_at_expansion (num_asts < 1000 for index > 1024). Other hunks (polling, m_fixed ordering) were left untouched.

check.sh output:
    ASSERTION VIOLATION
    File: <z3-src>/src/test/seq_limits.cpp
    Line: 46
    Failed to verify: m.get_num_asts() < 1000
    
