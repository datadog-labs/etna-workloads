# Adapted injection for Overhaul token collection.

Fix: https://github.com/rust-lang/rust/commit/9d31f86f0d1482b4e5084579238009cc5d98e49f

The fix added `UsePreAttrPos` / `pre_attr_pos` to `collect_tokens`; in 1.99.1 that machinery already exists, so the bug is re-injected by never using the pre-attr position (the pre-fix behaviour).

- parser/expr.rs `parse_expr_force_collect`: `if is_assoc { Yes } else { No }` -> `if is_assoc && false {..}`. Re-expresses the fix's expr.rs hunk that added `pre_attr_pos`/`UsePreAttrPos::Yes` for associative expressions (collect from before the outer attr).
- parser/stmt.rs `parse_stmt_without_recovery` (two sites, ~l.148 and ~l.186): `UsePreAttrPos::Yes` -> `UsePreAttrPos::No`. Re-expresses the fix's stmt.rs hunks (`Ok((expr, Trailing::No, UsePreAttrPos::Yes))`) for the two expression-statement cases.
