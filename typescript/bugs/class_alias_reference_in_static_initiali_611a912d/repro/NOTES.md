Input: a legacy-decorated class with static initializers that reference the class itself (`static x = C.name`), compiled with `--experimentalDecorators --target es2022`.
Clean: emits a `static { C_1 = this; }` block first, so the alias is assigned before the static initializers run.
Injected: omits that block and assigns `C_1 = class ...` outside the class, so the static initializers see an unassigned alias.
