Reloads a module in sys.modules with no `__spec__`. Clean: raises ModuleNotFoundError
("spec not found for the module 'spam'"). Buggy: the missing None-spec check lets
`_exec(None, module)` run, giving a different error (AttributeError) instead.
