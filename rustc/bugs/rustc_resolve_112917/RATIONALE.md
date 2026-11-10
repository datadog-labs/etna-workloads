# Adapted injection for add testcase for 112590

Fix: https://github.com/rust-lang/rust/commit/b26701ea7964d444f32a43710a763eb0989d9d7e

# Rationale
File: compiler/rustc_resolve/src/late/diagnostics.rs, fn `smart_resolve_partial_mod_path_errors`.
Re-expresses fix hunk `@@ -334,16 +334,36 @@ ... smart_resolve_partial_mod_path_errors`, which added the
"double check next seg is valid" filter (`self.r.resolutions(module)...any(|(key,_r)| key.ident.name == next_seg.ident.name)`).
The buggy parent suggested every module matching the prefix ident without checking that it contains the following segment.
I removed that resolutions/following-segment check (kept the later-added parent-module exclusion).
The other hunks (threading full_path, call-site moves) were refactors in 1.99.1 and are not needed.
