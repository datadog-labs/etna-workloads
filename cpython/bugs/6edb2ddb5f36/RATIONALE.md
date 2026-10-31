# Rationale

Changed `Modules/pyexpat.c`, in `pyexpat_xmlparser_ExternalEntityParserCreate_impl`:
`new_parser->parent = Py_NewRef(self);` became `new_parser->parent = NULL;`.

This reverses the fix's `Py_INCREF(self)` plus `new_parser->parent = self` hunks. In v3.15.2 those are
merged into one `Py_NewRef` line. The subparser no longer holds a strong reference to its parent.
The other hunks of the fix (the `parent` field, `Py_VISIT`, `Py_CLEAR` in dealloc, init to NULL)
stay in place. They are harmless once `parent` is always NULL for subparsers.

The parent parser can then be freed while a subparser still uses its `XML_Parser` inside libexpat.
That is the use-after-free from gh-139400.

## Oracle
The `ParentParserLifetimeTest` cases (`single`, `multiple`, `chain`) do `del parser` while a subparser
is alive. The run crashes (incomplete run) and 29 of 89 oracle cases are reported failing, including
all three of those cases. The later cases are counted as failing because the run aborted.
