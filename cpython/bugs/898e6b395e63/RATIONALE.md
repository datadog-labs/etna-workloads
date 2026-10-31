# Rationale

Bug (gh-130881): annotations in conditionally executed blocks (if/for/while/try/with/match, and
any module-level annotation) were all added to `__annotate__`'s dict, even when the
`AnnAssign` never ran. The fix added `__conditional_annotations__` tracking.

## Change: `Python/compile.c`, `_PyCompile_AddDeferredAnnotation`
Reverses the fix's hunks in `_PyCompile_AddDeferredAnnotation` / codegen that record a
conditional index (module scope or `u_in_conditional_block`). Now every annotation gets index -1
("unconditional"), so `codegen_process_deferred_annotations` never emits the
`index in __conditional_annotations__` check and the `__annotate__` function evaluates every
annotation, as before the fix. The rest of the machinery is left in place but is inert.

## Oracle failures
ConditionalAnnotationTests (test_simple_if, test_if_elif, test_for, test_while, test_try,
test_try_star, test_with, test_match, test_nesting_*): annotations from branches not executed
appear in `__annotations__`. Also RegressionTests.test_conditional_annotations_rebound.
