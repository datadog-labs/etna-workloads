Reproducer: runs a `for i in [1,2,3,4]` loop in a function with local BRANCH_LEFT/BRANCH_RIGHT
monitoring enabled (INSTRUMENTED_FOR_ITER on a list) and prints the sum.
Clean: prints `10`, exit 0. Buggy: the list index is never incremented, so the loop never ends (hang/timeout).
