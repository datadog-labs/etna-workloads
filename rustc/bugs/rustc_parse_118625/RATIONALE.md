# Adapted injection for Handle methodcalls & operators in patterns

Fix: https://github.com/rust-lang/rust/commit/6f014a81b2466c2abdae4c06ff81fae7e1bc006c

# Rationale
File: compiler/rustc_parse/src/parser/expr.rs, fn `check_assoc_op`.
Removed `AssocOp::Range(_)` from the arm that returns None under `Restrictions::IS_PAT`.
Re-expresses fix hunk `@@ -444,6 +444,19 @@ impl<'a> Parser<'a>` in expr.rs, which added
"stop parsing when encountering an assignment `=`, an alternative `|`, or a range `..`"
(`AssocOp::Assign | AssignOp | BitOr | DotDot | DotDotEq` if IS_PAT => return None).
Without the range part, the recovered trailing expression in a pattern swallows `..`/`..=`.
