# Adapted injection for Detect more cases of `=` to `:` typo

Fix: https://github.com/rust-lang/rust/commit/bde2dfb127a524321d6629607df5f3008921327e

# Rationale
File: compiler/rustc_parse/src/parser/stmt.rs, fn parse_full_stmt, arm `StmtKind::Local(local) if let Err(mut e) = self.expect_semi()`, `LocalKind::Decl` branch.

Fix hunk: `@@ -758,7 +772,47 @@` — `-    LocalKind::Decl => return Err(e),` replaced by a block that labels `colon_sp` ("while parsing the type for ...") and, if `suggest_eq`, adds the "use `=` if you meant to assign" suggestion.
I restored the pre-fix `LocalKind::Decl => return Err(e),`, so a fully parsed `let x: T` not followed by `;` no longer mentions the `:` or suggests `=`.
The other hunks (colon_sp field, descr, pub fns) are kept: they are only plumbing and don't change behaviour on their own.
