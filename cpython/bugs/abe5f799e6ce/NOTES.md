Creates `TypeAliasType("TA", list[int], type_params=())` and subscripts it.
Clean: raises TypeError "Only generic type aliases are subscriptable".
Buggy: the empty tuple makes the alias generic, so `TA[int]` returns a GenericAlias.
