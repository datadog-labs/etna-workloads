Compiles the gh-120225 regression snippet (async function with match/guard and an async dict comprehension).
Clean: prints "compiled". Buggy: aborts with assertion failure in remove_unreachable (flowgraph.c:1040)
because the reachability analysis's `visited` tracking was reverted. (The gh-124871 snippet from the fix's
new test does not trigger the assert in this build; this one does.)
