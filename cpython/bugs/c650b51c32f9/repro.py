import _testinternalcapi
import ast
tree = ast.parse("pass", mode="exec", optimize=1)
insts, meta = _testinternalcapi.compiler_codegen(tree, "<s>", 0)
print(repr(meta.get("consts")))
try:
    _testinternalcapi.optimize_cfg(insts, (0,), 0)
except Exception as e:
    print(type(e).__name__, e)
