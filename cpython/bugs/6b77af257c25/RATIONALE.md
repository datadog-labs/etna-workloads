# Rationale

Only `Python/flowgraph.c` (`optimize_load_fast`) changed. The fix's flowgraph hunks added special handling so that opcodes leaving operands on the stack are not treated as consuming everything. I removed that handling, so those opcodes fall through to the `default` case ("consume all inputs, push NOT_LOCAL"), which is the pre-fix behaviour:

- `case FORMAT_SIMPLE:` removed from the "consume no inputs" list (fix hunk 1). FORMAT_SIMPLE can leave a str operand on the stack, so a LOAD_FAST feeding it was wrongly borrowed (the gh-134889 repro).
- The `END_SEND` and `SET_FUNCTION_ATTRIBUTE` case (fix hunk 2; in v3.15.2 these are two separate cases) was removed. The `END_SEND` handling is the v3.15.2 form of the same defect.
- The `LOAD_SPECIAL`/`PUSH_EXC_INFO` case was removed (fix hunk 3).
- `GET_YIELD_FROM_ITER` was already absent from the list in v3.15.2, so nothing to revert there. The magic-number bump is not reverted.

Failing oracle cases (test_peepholer, OptimizeLoadFastTestCase): test_format_simple, test_load_special, test_push_exc_info, test_set_function_attribute. They fail because LOAD_FAST is wrongly optimized to LOAD_FAST_BORROW, or because the expected output has the wrong opcode.
