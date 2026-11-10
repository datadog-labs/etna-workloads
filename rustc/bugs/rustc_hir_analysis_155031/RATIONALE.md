# Adapted injection for Fix unelided lifetime ICE, refactoring of GenericArgPosition

Fix: https://github.com/rust-lang/rust/commit/9e8069fef155bb7bce7418f50c73c87e642a3b31

# Re-injection
Fix PR removed the `pos: GenericArgPosition` parameter from `lower_generic_args_of_path`; it always uses `GenericArgPosition::Type`. Before the fix, delegation passed `GenericArgPosition::Value` for the child (fn) segment, so lifetime-count checks were skipped (and the unelided lifetime ICE 154178 could occur).

- hir_ty_lowering/mod.rs `lower_generic_args_of_path`: re-added `pos: GenericArgPosition` param and pass it to `check_generic_arg_count` (fix hunk `@@ -640,8 +631,14 @@`, `-check_generic_arg_count(self, def_id, segment, generics, pos, ...)`; `@@ -617,7 +609,6 @@ -pos: GenericArgPosition`). Other callers (mod.rs x4) pass `GenericArgPosition::Type` (hunks -561, -826, -945, -1121).
- delegation.rs `get_delegation_user_specified_args`: trait segment passes `Type`; child segment passes `GenericArgPosition::Value(IsMethodCall::No)` (hunks `@@ -581,14 +581,7 @@` and `@@ -610,14 +603,7 @@`, which removed `GenericArgPosition::Value`), plus import (hunk 1).
