Looks up the opcode number of the specialized opcode BINARY_OP_ADD_INT and prints `opcode.opname[...]` for it.
Clean: 'BINARY_OP_ADD_INT'. Buggy: '<N>' placeholder, because opcode.opname no longer includes `_specialized_opmap` entries.
