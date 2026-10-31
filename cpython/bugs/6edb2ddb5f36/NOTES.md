# repro.py

Creates an expat parser, derives an external-entity subparser from it with
`ExternalEntityParserCreate`, then drops the only remaining reference to the
parent parser (`del parent` + `gc.collect()`) before using the subparser to
parse some bytes.

A correctly-implemented subparser must keep its parent parser alive, because
internally Expat's sub-parser still points into data owned by the parent
`XML_Parser` structure. The upstream fix (`fix.patch`) does this by having
`new_parser->parent = Py_NewRef(self)` in `xmlparse_ExternalEntityParserCreate`,
so the parent object (and the C-level `XML_Parser` it wraps) stays alive for as
long as any subparser referencing it exists.

`injection.patch` reverts this to `new_parser->parent = NULL`, so once the
Python-level `parent` object's refcount drops to zero, its `XML_ParserFree` is
called and the subparser is left holding a dangling pointer into freed memory.

## Observed difference

- `python-clean` (fix applied): prints
  `ExpatError('syntax error: line 1, column 0')` and exits 0 — parsing simply
  fails because "<a/>" isn't a valid entity-fragment in this context, but no
  memory corruption occurs since the parent stays alive.
- `python-buggy` (bug injected): segfaults, exiting with status -11 (SIGSEGV),
  because `sub.Parse()` dereferences state in the already-freed parent
  `XML_Parser`.
