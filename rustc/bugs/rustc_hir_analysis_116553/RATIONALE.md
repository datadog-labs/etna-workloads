# Adapted injection for Do not suggest 'Trait<Assoc=arg>' when in trait impl

Fix: https://github.com/rust-lang/rust/commit/079b29043976afd44cf49eec74486bf2fc15973d

Hunk: compiler/rustc_hir_analysis/src/diagnostics/wrong_number_of_generic_args.rs, suggestion for unbound assoc items (~line 1017).
Re-expresses fix hunk `@@ -948,20 +986,26 @@` which wrapped the "replace the generic bound with the associated type" suggestion in `if !self.is_in_trait_impl()` ("Don't suggest if we're in a trait impl ... fixes #116464"). The guard is now `if true`, so the suggestion is emitted in trait impls again (is_in_trait_impl left unused, as before the fix).
