Reproducer: a class body declares `nonlocal sequence_b` and annotates `y: sequence_b[int]`. `get_annotations(..., format=FORWARDREF)` returns ForwardRefs, and the nonlocal is bound afterwards. Then `.evaluate()` is called on each ForwardRef.

Clean: prints `<class 'list'>` and `list[int]`.
Buggy: `transmogrify` no longer stores the closure cells on the ForwardRef, so evaluating `y` raises `NameError: name 'sequence_b' is not defined` (exit status 1).
