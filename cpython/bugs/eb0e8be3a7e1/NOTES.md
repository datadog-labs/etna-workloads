# Notes

`repro.py` builds a DTD `<!ELEMENT root (a, (a, (a, ... )))>`-style content
model nested 500,000 levels deep and feeds it to `xml.parsers.expat`'s
`ParserCreate().Parse()`, with an `ElementDeclHandler` set so that expat's
C callback `modify_model`/`conv_content_model` runs and recursively walks
the nested `XML_Content` tree to build the equivalent Python tuple
structure.

`conv_content_model` in `Modules/pyexpat.c` recurses once per nesting
level. The fix (and the clean v3.15.2 build) wraps that recursion with
`_Py_EnterRecursiveCall()` / `_Py_LeaveRecursiveCall()`, so sufficiently
deep nesting raises a Python `RecursionError` instead of overflowing the C
stack.

`injection.patch` removes that recursion guard. With it removed, the same
500,000-level-deep content model recurses in C with no depth check and
overflows the C stack.

Observed difference:
- `bin/python-clean`: prints `RecursionError`, exits 0.
- `bin/python-buggy`: crashes with SIGSEGV (exit status -11) before
  printing anything.
