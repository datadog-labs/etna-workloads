# Adapted injection for fix(debuginfo): disable overflow check for recursive non-enum types

Fix: https://github.com/rust-lang/rust/commit/49eda8edd5c99e4c65c687fff0b8e194eb339a23

# Rationale
File: compiler/rustc_codegen_llvm/src/debuginfo/metadata/type_map.rs, fn build_type_with_children.

The fix's hunk (`@@ -285,8 +285,8 @@`, `let is_expanding_recursive = adt_def.is_enum() && ...`) limited the
expanding-recursion check to enums, so non-enum recursive types (struct/Arc/Box cycles) are not pruned.
In 1.99.1 the check was already rewritten (stack/ancestor logic, no `is_enum`), and the hunk no longer applies.
To restore the over-eager pruning for non-enum types, I removed the extra guard
(`stack[ancestor_index+1..].iter().all(... mid_arg.contains(ancestor_arg))`) so any type whose arg strictly
contains an ancestor's arg is treated as expanding-recursive, even in the cyclic struct test, and its members are dropped
(empty `elements`), the symptom from issue 143241.
