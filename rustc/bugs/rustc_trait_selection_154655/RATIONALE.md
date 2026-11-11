# Adapted injection for Fix associated bound suggestion span issue

Fix: https://github.com/rust-lang/rust/commit/95d5ecf3ab075e82503f4fb40893ac5899442653

One hunk: note_and_explain.rs, `note_and_explain_type_err` (Param vs Projection arm).
Re-expresses fix hunk `@@ -105,7 +105,13 @@`: the fix added `param_def_id` (the projection's self-type param, instead of the mismatched param `p`) and used it for `let parent = param_def_id.as_local()...`. I removed `param_def_id` and restored `p_def_id.as_local()`, so the "further restricting this bound" suggestion targets the wrong param's generics (E instead of T).
