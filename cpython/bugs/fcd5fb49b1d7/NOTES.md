repro.py: a function whose inlined list comprehension reuses the parameter name `x` as its iteration variable, with a lambda closing over it (`[lambda: x for x in range(x)], x`), taken from test_inner_cell_shadows_outer_no_store.

Clean: prints `2 [1, 1]`.
Buggy: the cell var isn't promoted in the outer scope, so `range(x)` receives the cell object and raises `TypeError: 'cell' object cannot be interpreted as an integer` (exit 1).
