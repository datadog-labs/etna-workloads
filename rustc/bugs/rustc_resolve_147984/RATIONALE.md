# Adapted injection for resolve: Preserve ambiguous glob reexports in crate metadata

Fix: https://github.com/rust-lang/rust/commit/51780a53f65906e5fd3ee213fb005a0864cfc06a

# Rationale
One hunk: compiler/rustc_resolve/src/imports.rs, `finalize_resolutions_in`.
Re-expresses fix hunk `@@ -1553,26 +1555,46 @@ ... finalize_resolutions_in`, where the fix added
`if let Some((ambig_binding1, ambig_binding2, ambig_kind)) = binding.descent_to_ambiguity() { ... ambig_children.push(AmbigModChild{..}) } else { children.push(child(...)) }`.
The buggy parent just pushed every binding as a plain `ModChild` (`children.push(...)`), dropping the second ambiguous binding, so ambiguity is not preserved in metadata. I removed the ambiguity branch; ambig_children stays empty so nothing is encoded.
