# Rationale

Fix hunk reversed: `_GenericAlias.__init__` in `Lib/typing.py` (the fix's
`enforce_default_ordering = origin in (Generic, Protocol)` hunk). In v3.15.2
`_collect_parameters` is now `_collect_type_parameters` and already has the
`enforce_default_ordering` keyword (the first hunk is unchanged), so I only
reverted the caller: `_GenericAlias.__init__` again calls
`_collect_type_parameters(args)` with the default `enforce_default_ordering=True`,
as before the fix. Default-ordering checks therefore apply to every alias,
not only `Generic[...]`/`Protocol[...]`.

Failing oracle case: `test_typing` `test_allow_default_after_non_default_in_alias`
(`Callable[[T_default], T]` raises "Type parameter ~T without a default follows
type parameter with a default"). Confirmed by check.sh (1 error).
