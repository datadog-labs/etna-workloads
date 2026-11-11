# Adapted injection for Emit error when using path-segment keyword as cfg pred

Fix: https://github.com/rust-lang/rust/commit/fc822f8c85989b318511a7a8b8e7a0491ef8abdf

# Re-injected bug: path-segment keywords accepted as cfg predicates

1. compiler/rustc_attr_parsing/src/attributes/cfg.rs, `parse_cfg_entry`: removed
   `.filter(|s| !s.is_path_segment_keyword())` on `meta.path().word_sym()` for the
   Word/NameValue arm. Re-expresses fix hunk `@@ -82,7 +82,8 @@ pub fn parse_cfg_entry`.
   So `#[cfg(self)]`, `#[cfg(crate)]`, `#[cfg(super)]` are accepted silently.
2. compiler/rustc_interface/src/interface.rs, `parse_cfg`: removed the
   `if ident.is_path_segment_keyword() { error!("malformed `cfg` input, ...") }` check
   (fix hunk `@@ -62,36 +63,46 @@ parse_cfg`).
3. Same file, `parse_check_cfg`: removed the same check before `names.push(ident)`
   (fix hunk `@@ -209,6 +222,11 @@ parse_check_cfg`).
Other fix hunks (cfg_old.rs, FatalOnlyEmitter rename, Recovery::Forbidden) were not
re-injected; the 1.99.1 code already differs and the keyword checks are the core of the bug.
