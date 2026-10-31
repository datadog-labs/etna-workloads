import opcode
import _testinternalcapi

def optimize(insts):
    seq = _testinternalcapi.new_instruction_sequence()
    for name, arg, line in insts:
        seq.addop(opcode.opmap[name], arg or 0, line, -1, -1, -1)
    out = _testinternalcapi.optimize_cfg(seq, [None], 0)
    return [(opcode.opname[op], arg) for op, arg, *_ in out.get_instructions()]

tail = [("LOAD_COMMON_CONSTANT", 7, 8), ("RETURN_VALUE", None, 9)]

# LOAD_FAST must not be borrowed: these ops leave their operand on the stack.
print(optimize([("LOAD_FAST", 0, 1), ("FORMAT_SIMPLE", None, 2), ("STORE_FAST", 1, 3)] + tail))
print(optimize([("LOAD_FAST", 0, 1), ("PUSH_EXC_INFO", None, 2)] + tail))
print(optimize([("LOAD_FAST", 0, 1), ("LOAD_SPECIAL", 0, 2), ("STORE_FAST", 1, 3)] + tail))
print(optimize([("LOAD_CONST", 0, 1), ("LOAD_FAST", 0, 2),
                ("SET_FUNCTION_ATTRIBUTE", 2, 3), ("STORE_FAST", 1, 4)] + tail))
