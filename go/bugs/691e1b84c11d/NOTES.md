`repro.go` is the `h()` case from `test/fixedbugs/issue45706.go` (the test the fix added), wrapped in a runnable `main`. It contains `for arr[x], arr2[arr[f()]][x] = range "" {}`.

- go-clean: compiles and runs, exit 0, no output.
- go-buggy: internal compiler error, exit 1: `'main': value .autotmp_5 (v88) incorrectly live at entry`.

The injection removes the fix that evaluates init statements of an lvalue before its saved sub-operands. That evaluation is now done only after the array-OINDEX layers have been peeled off, so an init statement on an inner index expression is ordered wrongly.
