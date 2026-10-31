Calls issubclass(GenericAlias, object/type) for list[int] and tuple[int, str].
Clean: raises TypeError. Buggy: returns True / False, because `__bases__` is
no longer forwarded-blocked on GenericAlias, so issubclass accepts the alias as a class.
