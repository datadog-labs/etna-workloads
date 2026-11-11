# Adapted injection for Ensure nested allocations in statics do not get deduplicated

Fix: https://github.com/rust-lang/rust/commit/d3514a036dc65c1d31ee5b1b4bd58b9be1edf5af

# Re-injection of #79738 (nested allocations in statics get deduplicated)

Only one file was changed: `compiler/rustc_const_eval/src/interpret/intern.rs`.

## Hunk 1: `intern_shallow`
Today, when interning happens while a static is being evaluated (`ecx.machine.static_def_id()` is `Some`),
each nested allocation is turned into its own anonymous nested static via `intern_as_new_static`.
I removed that branch, so every nested allocation goes through `ecx.tcx.set_alloc_id_memory(alloc_id, alloc)`
again. That makes it a plain `GlobalAlloc::Memory` that codegen/metadata can duplicate or deduplicate.
The result: a static that copies a pointer from another static (in the same crate or another crate) gets a different
address from the original. `disambiguator` is now only consumed (`let _ = disambiguator;`), so the signature
stays the same.

Re-expresses fix hunk `@@ -67,10 +83,35 @@ fn intern_shallow<...>`:
```
-    ecx.tcx.set_alloc_id_memory(alloc_id, alloc);
+    if let Some(static_id) = ecx.machine.static_def_id() {
+        intern_as_new_static(ecx.tcx, static_id, alloc_id, alloc);
+    } else {
+        ecx.tcx.set_alloc_id_memory(alloc_id, alloc);
+    }
```

## Hunk 2: removal of `intern_as_new_static`
This function had no callers left, so I deleted it. The fix added it in the same hunk
(`+fn intern_as_new_static<'tcx>(... ) { let feed = tcx.create_def(static_id, sym::nested, DefKind::Static { .., nested: true }); tcx.set_nested_alloc_id_static(alloc_id, feed.def_id()); ... }`).

## Hunk 3: imports
I removed the imports that were now unused (`DefKind`, `DefPathData`, `CodegenFnAttrs`, `ConstAllocation`, `TyCtxtAt`,
`diagnostics`). This matches the fix's import hunk `@@ -13,12 +13,16 @@`
(`+use hir::def::DefKind;`, `+use rustc_middle::mir::interpret::{ConstAllocation, ...}`, `+use rustc_middle::query::TyCtxtAt;`).

## Left as is
The `HasStaticRootDefId` trait, `static_root_ids`, and the codegen, reachability and validity handling of nested statics
are still there. Nothing creates nested statics any more, so that code is simply never reached.
One harmless warning remains: `NestedStaticInThreadLocal` is never constructed.
