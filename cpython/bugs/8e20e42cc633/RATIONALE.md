# Rationale

## Objects/genobject.c, gen_close()
Reverses the fix hunk in `gen_close` that replaced `_PyFrame_ClearLocals(&gen->gi_iframe)`
with `gen_clear_frame(gen)`. In v3.15.2 the line is `gen_clear_frame(gen)` (after setting
the state to FRAME_CLEARED); I restored `_PyFrame_ClearLocals(&gen->gi_iframe)`.
With that, the frame is not run through `_PyFrame_ClearExceptCode` (so a live frame object
is not given ownership/copied via `take_ownership`, `previous` is not unlinked, and the exc
state is not cleared). The state is already FRAME_CLEARED, so a later `gen_dealloc` skips
clearing, and frames/f_locals that outlive the generator reference freed memory.

The `gen_clear_frame` helper and the `gen_dealloc` hunk of the fix are already in the tree
and equivalent to the fixed form; they were left untouched.

## Oracle results
`./check.sh`: the interpreter crashes (assert/segfault) in test_generators; 27 of 51
oracle cases fail, including GeneratorDeallocTest.test_frame_outlives_generator,
test_frame_locals_outlive_generator and test_frame_locals_outlive_generator_with_exec
(the tests added by the fix). The others fail because the run aborts.
