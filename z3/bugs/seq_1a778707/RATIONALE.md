# Rationale
Changed hunk: seq_rewriter.cpp, split_bag suffix loop condition. FIX.diff hunk 2 added `&& (i > 0 || j > 0)` so a bag match covering the whole equation is not treated as a split point. I removed that guard again (other hunks already in a state where reversal changes nothing observable). Now abc = bca matches as a whole-equation bag, yielding the same equation as a new equality, so the solver does not make progress (test 25 hangs and is killed by the 120s timeout).

Final ./check.sh output:
BUILD OK
./check.sh: line 16: 32 Killed timeout -s KILL 120 setsid ../../build/test-z3 seq_rewriter
FAIL seq_rewriter (rc=137)
