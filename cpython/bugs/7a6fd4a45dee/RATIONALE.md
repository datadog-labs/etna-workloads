# Rationale

Fix hunk reversed: `Python/codegen.c` `codegen_annassign`. The fix split the
`LOAD_DEREF`/`LOAD_NAME` choice so `LOAD_NAME` of `__conditional_annotations__`
uses the `names` oparg dict. In v3.15.2 this lives at the same spot (~line 5731).
I restored the pre-fix behaviour: the `LOAD_NAME` branch is passed `cellvars`
again (the old ternary used `cellvars` for both opcodes), so the oparg is an
index into the cellvars/fast-hidden table instead of names. When a module-level
comprehension (inlined) adds cellvars, the index resolves to the wrong name.

The magic number bump and NEWS/test hunks were not reverted (not behavioural).

Failing oracle cases: `test_type_annotations.RegressionTests.test_module_level_annotation_plus_listcomp`
(all 3 subtests) fail with `TypeError: 'type' object is not a set`
(wrong name loaded, e.g. `Generic`).
