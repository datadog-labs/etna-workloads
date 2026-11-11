# Adapted injection for Item bounds can reference self projections and still be object safe

Fix: https://github.com/rust-lang/rust/commit/8edf9b808427dfbe4425b49d213351f907f58b40

# Hunk
compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, fn `bounds_reference_self` (line ~211).
Fix hunk `@@ -204,20 +210,25 @@ fn bounds_reference_self`: item bounds passed `AllowSelfProjections::Yes` ("Item bounds *can* have self projections"). Reintroduced the bug by passing `AllowSelfProjections::No`, so item bounds referencing `Self::Assoc` projections make the trait dyn-incompatible (pre-fix behaviour: any Self reference was illegal).
