# Rationale

Fix hunk (Lib/typing.py): added `'__type_params__'` to `_TYPING_INTERNALS`.
In v3.15.2 the set has a different layout (`__non_callable_proto_members__` replaced
`__callable_proto_members_only__`), so I removed `'__type_params__'` from the
same frozenset (Lib/typing.py, `_TYPING_INTERNALS`). This restores the bug: `__type_params__`
on PEP 695 generic protocols is treated as a protocol member, so isinstance/issubclass
checks against them fail.

Oracle: test_typing fails (2 failures, 4 errors), e.g. `test_inheritance_from_object`
(get_protocol_members includes `__type_params__`) and isinstance checks against
`typing.SupportsAbs` (PEP 695 generic protocols).
