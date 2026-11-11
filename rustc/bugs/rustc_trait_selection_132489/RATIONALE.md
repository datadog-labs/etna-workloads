# Adapted injection for Fix closure arg extraction in extract_callable_info

Fix: https://github.com/rust-lang/rust/commit/78bbc648c5b2e6e092167d2ed593cd89f06dd37f

# Hunk: suggestions.rs, extract_callable_info, ty::Closure arm
Fix hunk `@@ -1091,7 +1091,7 @@` replaced `fn_sig.inputs().map_bound(|inputs| &inputs[1..])` with `inputs[0].tuple_fields().as_slice()`.
Re-injected the old line `&inputs[1..]` in the closure arm: closure sig inputs is a single tupled arg, so the slice is empty and the "call this closure" suggestion shows no args. (The second fix hunk was formatting only.)
