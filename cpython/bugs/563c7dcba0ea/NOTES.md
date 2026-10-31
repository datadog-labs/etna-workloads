Reproducer: the test_nested_4 code (nested list comprehensions containing lambdas that capture the comprehension variable `x`), run inside a function.

Clean: prints `[([1, 1], 2), ([1, 1], 2), ([1, 1], 2)]`, exit 0.
Buggy: segfaults (exit -11). The injected symtable.c change leaves the cell variable out of the right cell/promotion handling, so the compiled code is wrong.
