# Adapted injection for mentioned_items: record all callee and coerced closure types, whether they are FnDef/Closure or not

Fix: https://github.com/rust-lang/rust/commit/0d6a16ac4b0905df17d93ed015ecb0a9a89c3484

# Re-injected bug
All edits are in `compiler/rustc_mir_transform/src/mentioned_items.rs` (MentionedItemsVisitor), reversing
the fix hunks `@@ -1,6 +1,6 @@` .. `@@ -80,17 +91,19 @@` of mentioned_items.rs:

1. New `visit_const_operand` (was `visit_constant` upstream): records `MentionedItem::Fn(ty)` only for
   constants of `FnDef` type, using the constant's span. Re-expresses the removed
   `fn visit_constant ... if let ty::FnDef(def_id, args) = const_.ty().kind()`.
2. `visit_terminator`: removed the `TerminatorKind::Call { func, .. } | TailCall` arm that recorded
   `MentionedItem::Fn(callee_ty)` unconditionally (fix: "mir::TerminatorKind::Call { func, .. } => ...").
   Old code said "We don't need to handle `Call` as we already handled all function type operands in `visit_constant`".
3. `visit_rvalue`: ReifyFnPointer arm no longer records `Fn(fn_ty)` (old comment: "Function pointer casts are
   already handled by `visit_constant` above"). Closure arm now only records when the source type is `ty::Closure`
   (fix: `match *source_ty.kind() { ty::Closure(..) => ... }` -> now unconditional).
Effect: callees that are not syntactically FnDef constants (generic / projection / opaque types that become FnDef
only after monomorphization) are not mentioned; spans of mentions are the constant's span instead of the call's.
Collector.rs/inline.rs left unchanged (the type-based `MentionedItem` representation is kept).
