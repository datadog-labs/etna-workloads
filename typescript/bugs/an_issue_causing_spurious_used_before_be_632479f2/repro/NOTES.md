Input: a `for (let x of [1, 2])` loop whose body declares a function that reads `x`, compiled with --strict.
Clean: no errors (exit 0).
Injected: the loop variable is treated as never initialized, so the use reports a spurious "Variable 'x' is used before being assigned" error.
