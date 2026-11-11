# Adapted injection for Normalize possibly unnormalized type in relate_type_and_user_type

Fix: https://github.com/rust-lang/rust/commit/9871e160eae4376dea2b9fa3aa1ccca3607fc1c3

# Rationale
File: compiler/rustc_borrowck/src/type_check/mod.rs, fn `relate_type_and_user_type`.
Re-expresses fix hunk `@@ -482,6 +482,9 @@` which added
`// Need to renormalize a ...` / `let a = self.normalize(a, locations);`.
On 1.99.1 this is the old-solver block `a = self.normalize(Unnormalized::new_wip(a), locations)`;
I removed that line (kept normalization of `ty`), so `a` is no longer renormalized.
