# Adapted injection for Deny `use`ing tool paths

Fix: https://github.com/rust-lang/rust/commit/ebde2ab363ea4cfff4fbb58ef821f3bcebc351a5

# Rationale
File compiler/rustc_resolve/src/ident.rs, fn resolve_path_with_ribs: in the `res == Res::ToolMod` branch, removed `&& opt_ns.is_some()` from the condition (now `res == Res::ToolMod && !is_last`).
Re-expresses fix hunk `@@ -1494,16 +1494,12 @@`: `-} else if res == Res::ToolMod && i + 1 != path.len()` / `+} else if res == Res::ToolMod && !is_last && opt_ns.is_some()`. Without the opt_ns check, import paths (opt_ns None) like `use clippy::time::Instant;` take the tool-module branch and return a NonModule result instead of the "`clippy` is a tool module, not a module" error.
