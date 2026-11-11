# Adapted injection for Fix ICE in suggestion caused by `⩵` being recovered as `==`

Fix: https://github.com/rust-lang/rust/commit/67ec1326ee4e360b92dc6a6a3834bf8948532770

Files: compiler/rustc_parse/src/diagnostics.rs (struct UseEqInstead; errors.rs was merged into diagnostics.rs) and compiler/rustc_parse/src/parser/diagnostics.rs (caller).
Re-expresses fix hunks `@@ -660,9 +660,8 @@ pub(crate) struct RemoveLet` (restores separate `suggestion: Span` field with code = "" instead of `span` with code = "=") and `@@ -566,10 +566,7 @@` (restores `suggestion: self.token.span.with_lo(self.token.span.lo() + BytePos(1))`, assuming `==` is 2 one-byte chars, which breaks for multi-byte `⩵`).
