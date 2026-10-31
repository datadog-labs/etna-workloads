# Rationale

## Change: `Objects/dictobject.c`, `store_instance_attr_lock_held`

Fix hunk reversed: the added `if (dict) { ... _PyDict_NotifyEvent(...) }` block
that fires ADDED/DELETED/MODIFIED events when an attribute is stored in the
inline values of an object whose managed `__dict__` has been materialized.
I removed that block from v3.15.2 (the `NotifyEvent` call there has the
current signature without `interp`, and the AttributeError check had already
been moved before it, so only the notification is removed). The code is
equivalent to the pre-fix behaviour: inline-value stores write directly to
`values->values[ix]` with no watcher notification.

## Oracle failures

`TestDictWatchers.test_object_dict` fails: after watching `o.__dict__`,
`o.foo = "bar"; o.foo = "baz"; del o.foo` yields `[]` instead of
`["new:foo:bar", "mod:foo:baz", "del:foo"]`. The other 59 cases pass.
