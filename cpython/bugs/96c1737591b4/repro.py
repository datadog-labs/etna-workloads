import dis, io, opcode
import _testinternalcapi

insts = [
    ('RESUME', 0), ('SETUP_FINALLY', 4), ('LOAD_CONST', 0), ('RETURN_VALUE', None),
    ('SETUP_CLEANUP', 10), ('PUSH_EXC_INFO', None), ('POP_TOP', None),
    ('POP_EXCEPT', None), ('LOAD_CONST', 0), ('RETURN_VALUE', None),
    ('COPY', 3), ('POP_EXCEPT', None), ('RERAISE', 1),
]
metadata = {'filename': 'exc.py', 'name': 'exc', 'qualname': 'exc', 'consts': {2: 0},
            'names': {}, 'varnames': {}, 'cellvars': {}, 'freevars': {}, 'fasthidden': {},
            'argcount': 0, 'posonlyargcount': 0, 'kwonlyargcount': 0, 'firstlineno': 1}
seq = _testinternalcapi.new_instruction_sequence()
for op, arg in insts:
    seq.addop(opcode.opmap[op], arg or 0, -1, -1, -1, -1)
co = _testinternalcapi.assemble_code_object('exc.py', seq, metadata)
out = io.StringIO()
dis.dis(co, file=out)
print(out.getvalue())
