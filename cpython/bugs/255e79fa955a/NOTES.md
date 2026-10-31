`repro.py` parses `{**x for x in ()}` and unparses it with `ast.unparse`.

- Clean: prints `{**x for x in ()}`, exit 0.
- Buggy: `visit_DictComp` calls `traverse(node.value)` with `value=None`. That raises `AttributeError: 'NoneType' object has no attribute '_fields'`, exit 1.
