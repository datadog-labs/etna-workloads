# Rationale

Both hunks are in `Python/symtable.c` and reverse the corresponding hunks of the fix.

1. `update_symbols`: the `classflag` branch for a symbol that already exists is again guarded by
   `PyLong_AsLong(v) & (DEF_BOUND | DEF_GLOBAL)`. The fix removed this guard. Today's code reads the
   flags with `PyLong_AsLong` (error-checked), so the guard is written the same way.
2. `analyze_block`: the `classflag` argument passed to `update_symbols` is `ste->ste_type == ClassBlock` only.
   The fix added `|| ste->ste_can_see_class_scope`. Without it, type-param scopes inside a class do not
   propagate `DEF_FREE_CLASS`, so a free variable is not marked as a class free var.

## Oracle
`test_type_params` has 4 errors, including `test_nested_free`. It fails with
`SystemError: compiler_lookup_arg(name='T') with reftype=3 failed in <generic parameters of D>`.
