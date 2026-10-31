Builds an instruction sequence (SETUP_FINALLY -> handler label, POP_BLOCK, return, handler)
via `_testinternalcapi` and runs `optimize_cfg`, then prints the instructions.
Clean: SETUP_FINALLY's oparg is the handler label id (3). Buggy: the label oparg is not
set for the except-handler target (HAS_TARGET replaced by OPCODE_HAS_JUMP in flowgraph.c),
so the oparg is garbage (-111).
