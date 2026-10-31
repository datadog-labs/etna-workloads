import opcode
import _testinternalcapi

op = opcode.opmap
seq = _testinternalcapi.new_instruction_sequence()
seq.addop(op['SETUP_FINALLY'], 0, 10, -1, -1, -1)
seq.addop(op['POP_BLOCK'], 0, -1, -1, -1, -1)
seq.addop(op['LOAD_CONST'], 1, 11, -1, -1, -1)
seq.addop(op['RETURN_VALUE'], 0, 11, -1, -1, -1)
seq.use_label(0)
seq.addop(op['LOAD_CONST'], 2, 12, -1, -1, -1)
seq.addop(op['RETURN_VALUE'], 0, 12, -1, -1, -1)
insts = _testinternalcapi.optimize_cfg(seq, list(range(5)), 0)
for i in insts.get_instructions():
    print(i)
