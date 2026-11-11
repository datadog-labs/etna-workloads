# Adapted injection for Init self_decl with a correct vis

Fix: https://github.com/rust-lang/rust/commit/01795c3eabbeca6e2a80c02385867ec055e3b7c7

# Rationale
File compiler/rustc_resolve/src/lib.rs, `Resolver::new_local_module` (the 1.99.1 equivalent of the fix's `new_local_module`/`arenas.new_module` hunks, @@ -1765 / -1749 `let vis = kind.opt_def_id().map_or(Visibility::Public, |def_id| self.tcx.visibility(def_id));`).
The fix computes the module's real visibility and passes it so `self_decl` (used for `self`/`super` paths) gets the correct vis. I reverted to the old behaviour: always pass `Visibility::Public`, so `self_decl` is pub and `pub use self as x` is wrongly accepted.
Other hunks (opt_def_id helper, signature plumbing) are refactors and were left as-is since 1.99.1 already plumbs `vis` through ModuleData::new.
