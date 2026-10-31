# Rationale

Fix hunk reversed: the `Python/flowgraph.c` hunk that made `_PyCfg_JumpLabelsToTargets`
also call `label_exception_targets()` after `translate_jump_labels_to_targets()`.
In v3.15.2 the function (now at the end of the file) still has both calls, so I
removed the `label_exception_targets` call. It again only translates jump labels,
which is the pre-fix behaviour. `_PyCompile_Assemble` therefore gets a synthetic CFG
with no exception handler targets, and the exception table is empty.

Oracle failure: `test_compiler_assemble.IsolatedAssembleTests.test_exception_table`
fails. The disassembly of the assembled code object has no `ExceptionTable:` section.
The other two cases still pass.
