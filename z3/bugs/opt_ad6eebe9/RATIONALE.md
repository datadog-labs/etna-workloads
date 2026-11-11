# Rationale
One hunk in src/src/opt/optsmt.cpp: the destructor of the local `scoped_pushes` guard
(`~scoped_pushes() { reset(); }`) now does nothing.
Traces to the first hunk of FIX.diff (introduction of `scoped_pushes`, whose destructor removes
the temporary trial-bound scopes on exit) and the "remove leftover trial bounds on cancellation
and exceptions" behaviour. In today's code the guard already exists, so undoing its cleanup-on-exit
restores the pre-fix behaviour: manual push counters whose scopes leak when an exception or
early exit occurs between push and pop. The oracle opt_bounds then fails on a scope-level
assertion (`s.get_scope_level() == 1`).

## check.sh output
    opt_bounds: arithmetic scope exits
    opt_bounds: certified nonlinear dual bounds
    opt_bounds: geometric step schedule
    opt_bounds: signed algebraic optima and offsets
    opt_bounds: lexicographic and box handles
    opt_bounds: lexicographic objectives after an unbounded objective
    opt_bounds: linear relaxation bounds for MaxSMT
    opt_bounds: finite open bounds and polynomial objectives
    opt_bounds: open lexicographic and box handles
    opt_bounds: recheck, scopes, and unknown intervals
    ASSERTION VIOLATION
    File: <z3-src>/src/test/opt_bounds.cpp
    Line: 1592
    Failed to verify: s.get_scope_level() == 1
    
