# Adapted injection for Make resolved assoc ty paths induce a trait object lifetime default for their self ty

Fix: https://github.com/rust-lang/rust/commit/a7ae154c526a1d25e174f886b3f1802388fa7ae4

# Rationale
File: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, fn `visit_qpath`, `QPath::Resolved` arm.
Re-expresses fix hunk `@@ -904,13 +904,31 @@ ... fn visit_qpath`. The fix removed
`// FIXME(fmease): Make assocated type paths induce a trait object lifetime default for the self type, too!`
and `Scope::ObjectLifetimeDefault { lifetime: None, ... }` for qself, replacing it with a computed default
(visit path first, then qself under the container's first computed default). I restored the old code:
qself is visited first under `ObjectLifetimeDefault { lifetime: None }`, then `visit_path`.
Other hunks (refactors of object_lifetime_default, Self param handling) were not reverted; they are only needed to support this.
