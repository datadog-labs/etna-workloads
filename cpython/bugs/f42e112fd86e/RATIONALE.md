# Rationale

Fix hunk: `Python/flowgraph.c` `_PyCfg_ToInstructionSequence`: condition
`OPCODE_HAS_JUMP(op)` became `OPCODE_HAS_JUMP(op) || is_block_push(instr)`.

In v3.15.2 the same condition is spelled `HAS_TARGET(op)` (= jump or block push).
I reverted that line to `OPCODE_HAS_JUMP(instr->i_opcode)`, so SETUP_FINALLY /
SETUP_WITH / SETUP_CLEANUP no longer get their oparg translated from the target
block to its label id; the stale oparg is emitted as the handler label.

Failing oracle cases (2 failures in test_peepholer): `test_except_handler_label`
(the case added by the fix; handler label comes out wrong, e.g. (264, 3) vs
(264, -111)) and one other test with a block-push instruction.
