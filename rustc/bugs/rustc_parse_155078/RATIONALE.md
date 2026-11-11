# Adapted injection for Reject dangling attributes in where clauses

Fix: https://github.com/rust-lang/rust/commit/3c6cf27ae423145e25bc9f6d88cd57d54d29e9a9

# Rationale
File compiler/rustc_parse/src/parser/generics.rs, fn parse_where_clause (the `else` branch of the predicate-kind parsing in the collect_tokens closure).
Removed the `if let [.., last] = &attrs[..] { if last.is_doc_comment() { emit DocCommentDoesNotDocumentAnything } else { emit AttrWithoutWherePredicates } }` block.
This re-expresses fix hunk `@@ -473,6 +473,17 @@ impl<'a> Parser<'a>` which added that block. Without it, dangling attributes/doc comments after the last where predicate are silently dropped.
The errors.rs hunk (AttrWithoutWherePredicates struct) is left in place (the struct now lives in diagnostics and is simply unused).
