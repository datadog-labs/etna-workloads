# Rationale

Fix: gh-114053 (typing.get_type_hints, PEP 695 + PEP 563). The fix changed ForwardRef evaluation so
type params are put in the globals (class scope names still win; params override module-level names
and drop shadowing entries from localns). In v3.15.2 that logic lives in
`_add_type_params_to_scope` in Lib/typing.py (called from get_type_hints).

Change: `_add_type_params_to_scope` now restores the pre-fix computation
`locals_to_pass = {param.__name__: param ...} | localns` (the removed lines of the hunk in
`ForwardRef._evaluate`), leaving globalns untouched. Type params therefore no longer override
globals, and are themselves overridden by names in the localns (module globals/class namespace),
so a global/class attribute with a type parameter's name wins wrongly.

Oracle failures: 5 test_typing cases fail, e.g. the get_type_hints tests on ann_module695 classes
(name clash with global vars / local shadowing): hints resolve to int/str instead of the
type parameters Spam/Eggs.
