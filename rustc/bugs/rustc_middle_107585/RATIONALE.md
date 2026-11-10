# Adapted injection for Don't cause a cycle when formatting query description that references a FnDef

Fix: https://github.com/rust-lang/rust/commit/64f5293956de9dc4e336906f1c7fef8415c292de

Both hunks are in compiler/rustc_middle/src/ty/print/pretty.rs (`pretty_print_type`).
The plumbing.rs hunk is not re-expressed. In 1.99.1 `with_no_queries!` was folded into `with_reduced_queries`, and the query-frame code moved.

1. `ty::FnDef` arm. Re-expresses fix hunk `@@ -675,8 +675,12 @@ ... ty::FnDef(def_id, substs)`, which added `if NO_QUERIES.with(..) { p!(print_def_path(..)) } else { fn_sig ... }`. I removed the `with_reduced_queries()` branch, so `fn_sig` is always queried, even while formatting a query description.
2. Opaque alias, fallthrough `_` arm. Re-expresses fix hunk `@@ -760,7 +766,14 @@`, which added `if NO_QUERIES { print_def_path(def_id, &[]) } else { pretty_print_opaque_impl_type }`. I restored the unconditional `return self.pretty_print_opaque_impl_type(def_id, args)`.
