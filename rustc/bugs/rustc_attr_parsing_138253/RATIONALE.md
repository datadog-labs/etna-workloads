# Adapted injection for continue to check attr if meet empty repr for adt

Fix: https://github.com/rust-lang/rust/commit/86013e629b00aba50f80810ed46c187531a3fdf9

# Rationale
File: compiler/rustc_attr_parsing/src/attributes/repr.rs, `ReprParser::extend`.
The fix hunk (`@@ -1998,7 +1998,7 @@ impl<'tcx> CheckAttrVisitor<'tcx>` in check_attr.rs) changed
`Target::Struct | Target::Union | Target::Enum => {}` to `=> continue`, so an empty `#[repr()]` on an ADT
no longer short-circuited the remaining checks. In 1.99.1 that logic moved into the attribute parser (empty list branch).
I re-introduced the old ADT-specific special case: for Struct/Union/Enum an empty `repr()` returns early and
skips `warn_empty_attribute`, so the "unused attribute" diagnostic is lost (the old code mishandled empty repr on ADTs).
This is an approximation, since the original code structure no longer exists.
