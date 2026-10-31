import ast
import _testinternalcapi

a = ast.parse("return 42", "my_file.py", "exec")
try:
    _testinternalcapi.compiler_codegen(a, "my_file.py", 0)
except SyntaxError as e:
    print(repr(e.msg), e.text, e.offset, e.end_offset)
