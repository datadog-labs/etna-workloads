import opcode
i = opcode._specialized_opmap['BINARY_OP_ADD_INT']
print(repr(opcode.opname[i]))
