# Adapted injection for Do not suggest borrow that is already there in fully-qualified call

Fix: https://github.com/rust-lang/rust/commit/bb74f4732739d41bfca4e0689a3f00dda0439c4d

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn suggest_add_reference_to_arg, `WhereClauseInExpr` arm.

Fix hunk `@@ -1195,6 +1195,15 @@` added an early `return false;` for `Call(base,_)` with `TypeRelative(ty,_)` and `ty.span == span`, with the comment "Do not suggest borrowing when we already do so ... `&str::from("")`".
In 1.99.1 that logic lives inside the first branch (the `&str::from("")` case), which ends in `return false;` ("If we didn't return early here, we would instead suggest `&&str::from("")`"). I removed that `return false;`, so control falls through to `c` and the extra borrow suggestion is produced again.
