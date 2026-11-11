# Adapted injection for add test to reproduce #137662 (using ty decl macro fragment in an attr) and fix it

Fix: https://github.com/rust-lang/rust/commit/41dd80aeaa706c169df62bdf16033b61b914cb87

# Rationale
Hunk: compiler/rustc_parse/src/parser/path.rs, `Parser::parse_path_inner`: removed the branch
`self.eat_metavar_seq(MetaVarKind::Ty { is_path: true }, |this| this.parse_path(PathStyle::Type))`.
Re-expresses fix.diff hunk `@@ -473,6 +473,15 @@ impl<'a> MetaItemListParserContext<'a>` in rustc_attr_parsing/src/parser.rs,
which added handling of an invisible-delimited (metavar) group in attribute meta item parsing (`Delimiter::Invisible` branch).
In 1.99.1 that parser uses the real Parser, and the equivalent code path that lets a `$x:ty` metavar be accepted as a path
in `#[repr($repr)]` is the Ty{is_path:true} metavar branch in parse_path; without it, `ty` fragments in attrs fail again.
