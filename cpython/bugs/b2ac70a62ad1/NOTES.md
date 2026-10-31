Reproducer: calls isinstance(obj, t) for Union/Optional types containing `Any`
or a parameterized generic (e.g. `Union[str, Any]`, `Optional[Any]`) and prints
the result or the TypeError.

Clean: always TypeError ("typing.Any cannot be used with isinstance()", etc.).
Buggy: Union.__instancecheck__ uses issubclass(type(obj), arg), so the Any
cases return False/True instead of raising, and the other messages mention
issubclass().
