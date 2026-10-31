# Rationale

The fix made `frame.f_locals` include the (hidden) iteration variables of
inlined module-/class-scope comprehensions. In v3.15.2 the old
`frame_getlocals` / `PyFrame_FastToLocalsWithError` code is gone (f_locals is a
write-through proxy), so the equivalent is the getter `frame_locals_get_impl`
in `Objects/frameobject.c` (reverses the `frame_getlocals` hunk).

Change: the shortcut that returns the plain `f_locals` dict for non-optimized
frames no longer checks `!_PyFrame_HasHiddenLocals(...)`. For a module/class
frame running an inlined comprehension, `f_locals` is again the bare
namespace dict without the comprehension's iteration variable, instead of a
proxy that exposes it. `_PyFrame_GetLocals` (used by `locals()`) is untouched.

Failing oracle cases: `test_listcomps.ListComprehensionTest.test_frame_locals`
(scopes 'module' and 'class') fail with `KeyError: 'a'`.
