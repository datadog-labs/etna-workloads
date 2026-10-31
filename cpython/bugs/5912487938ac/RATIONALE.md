# Rationale

Fix hunks reversed (all in `framelocalsproxy_getkeyindex`, Objects/frameobject.c):
the fix removed the `PyUnicode_CheckExact(key)` guards in getitem/setitem/contains
(and the `assert(PyUnicode_CheckExact(key))` in getkeyindex) so that any hashable key
is looked up among fast locals. In v3.15.2 the callers (getitem, setitem, contains,
and the 4th at line ~809) all go through `getkeyindex`, so a single
`if (!PyUnicode_CheckExact(key)) return -1;` at the top of it restores the pre-fix
behaviour for every caller: non-exact-str keys (str subclasses, objects hashing/comparing
equal to 'x') skip the fast locals and land in `f_extra_locals`.

Failing oracle cases: test_proxy_key_stringlikes_overwrite and
test_proxy_key_stringlikes_ftrst_write (StringSubclass/ImpostorX keys create an extra
key instead of overwriting local `x`), plus the unhashable/mapping tests (4 errors, 2 failures total in test_frame).
