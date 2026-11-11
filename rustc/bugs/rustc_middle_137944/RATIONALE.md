# Adapted injection for middle: print `{Meta,Pointee}Sized` in opaques

Fix: https://github.com/rust-lang/rust/commit/118d4e62c380a4dfb7a0c53a0001a19d0cee6567

# Re-injected bug
File: compiler/rustc_middle/src/ty/print/pretty.rs, fn `pretty_print_opaque_impl_type`.
Reverts both effective hunks of the fix (the first hunk didn't apply textually because of drift):
- Hunk `@@ -1069,24 +1069,35 @@`: the bound loop again only matches `LangItem::Sized` (via `is_lang_item`) and no longer tracks/skips `MetaSized` (`has_meta_sized_bound`) nor handles `PointeeSized`.
- Hunk `@@ -1255,8 +1266,13 @@` / `@@ -1265,6 +1281,16 @@`: restored `add_maybe_sized = !has_sized_bound && !has_negative_sized_bound` and removed the `MetaSized`/`PointeeSized` printing branches, so opaques always print `?Sized` instead of `MetaSized`/`PointeeSized`.
