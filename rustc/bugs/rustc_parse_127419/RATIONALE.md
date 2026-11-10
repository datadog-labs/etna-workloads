# Adapted injection for Add suggestions for possible missing `fn`, `struct`, or `enum` keywords

Fix: https://github.com/rust-lang/rust/commit/b40adc9d3b56f230f295011ff78b0dfd378683ef

# Rationale
File: compiler/rustc_parse/src/parser/item.rs, fn `parse_item_kind`, macro-invocation branch.
Removed the call `if self.isnt_macro_invocation() { self.recover_missing_kw_before_item()?; }` before `// MACRO INVOCATION ITEM`.
Re-expresses fix hunk `@@ -311,6 +312,9 @@` (`} else if macros_allowed && self.check_path() { + if self.isnt_macro_invocation() { + self.recover_missing_kw_before_item()?; }`), which added missing-`fn`/`struct`/`enum` recovery for items without `pub`. Without it, `foo() {}` etc. give generic macro-invocation errors.
