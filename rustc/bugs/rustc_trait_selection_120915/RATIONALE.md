# Adapted injection for Fix suggestion span for ?Sized

Fix: https://github.com/rust-lang/rust/commit/4ac90e286bd49663f6f29130df33fa17576b2765

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs (moved from error_reporting/suggestions.rs), in the Sized-obligation note code (`note_obligation_cause_code`-area). 
Re-expresses fix hunks `@@ -3042,7 +3042,7 @@` and `@@ -3054,7 +3054,7 @@`: the pattern binds `ident` instead of `generics`, and the `?Sized` suggestion for a bound-less associated type is inserted at `ident.span.shrink_to_hi()` instead of `generics.span.shrink_to_hi()`. With a generic assoc type (`type P<X>`) the suggestion lands before the `<X>`.
The other fix hunk (type_err_ctxt_ext.rs, `param.name.ident().span.shrink_to_hi()`) is already in 1.99.1 form and was not changed.
