Calls TypeAliasType with invalid type_params: non-type-param items, and a non-default
TypeVar following a default one. Clean raises TypeError ("Expected a type param...",
"non-default type parameter ... follows default type parameter"); the buggy build skips
that validation and silently accepts them (prints "no error" / different errors).
