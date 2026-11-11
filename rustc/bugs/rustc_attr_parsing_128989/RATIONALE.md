# Adapted injection for Emit an error for invalid use of the linkage attribute

Fix: https://github.com/rust-lang/rust/commit/3c8dad152bc1e3baca25e5b7b6b7ea6eccef060a

# Rationale
File: compiler/rustc_attr_parsing/src/attributes/link_attrs.rs, `LinkageParser::ALLOWED_TARGETS`.
In 1.99.1 the check was moved from check_attr.rs into the attribute parser's target allow-list
(Fn, Method, Static, ForeignStatic, ForeignFn). I replaced it with `AllowList(ALL_TARGETS)`, so
`#[linkage]` is accepted on any item again. This re-expresses the fix hunks in check_attr.rs
(`@@ -243,6 +243,7 @@ [sym::linkage, ..] => self.check_linkage(attr, span, target)` and the new
`fn check_linkage` that emitted `errors::Linkage` for targets other than Fn/Method/Static/ForeignStatic/ForeignFn),
plus the `passes_linkage` message. The fix removed the `sym::linkage // FIXME(linkage)` no-op entry; the
parent behaviour is that linkage is silently accepted anywhere.
