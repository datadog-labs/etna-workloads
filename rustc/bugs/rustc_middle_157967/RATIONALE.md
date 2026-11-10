# Adapted injection for fix(rustc_middle): preserve track_caller for vtable shims

Fix: https://github.com/rust-lang/rust/commit/b77dcf4641a02f5dd0e6da86ad22327786c55943

# Rationale
File: compiler/rustc_middle/src/ty/instance.rs, `InstanceKind::requires_caller_location`.
Removed `InstanceKind::Shim(ShimKind::VTable(def_id))` from the or-pattern with Item/Virtual (in 1.99.1 VTableShim became a ShimKind variant). This re-expresses the fix hunk `@@ -310,7 +310,9 @@ impl<'tcx> InstanceKind<'tcx>` which added `| InstanceKind::VTableShim(def_id)`. Without it, vtable shims don't take the caller-location arg, so track_caller is lost.
