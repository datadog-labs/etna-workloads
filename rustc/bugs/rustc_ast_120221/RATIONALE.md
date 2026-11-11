# Adapted injection for Don't make pattern nonterminals match statement nonterminals

Fix: https://github.com/rust-lang/rust/commit/c61f85b6dd47343abe6383ea2eb71f0b3a7d0e2b

# Hunk: compiler/rustc_ast/src/token.rs, `Token::can_begin_pattern`
Fix hunk `@@ -515,23 +521,32 @@ ... pub fn can_begin_pattern(&self, pat_kind: NtPatKind)` replaced the
old "any Interpolated nonterminal may begin a pattern" (`may_be_ident(nt)`) with an explicit list
(NtExpr, NtLiteral, NtMeta, NtPat, NtPath, NtTy), which excludes NtStmt.
In 1.99.1 the list is of `MetaVarKind` invisible delimiters; I added `MetaVarKind::Stmt`, so a `$stmt`
fragment is again treated as able to start a `pat`, making `m!{ $stmt }` match the `$pat` arm and error.
