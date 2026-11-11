# Adapted injection for Fix `break_last_token`.

Fix: https://github.com/rust-lang/rust/commit/73cc5751773d4c49cc9d938548762520037926ba

# Rationale
One hunk: compiler/rustc_parse/src/parser/mod.rs, `Parser::break_and_eat`.
Changed `self.break_last_token += 1;` to `self.break_last_token = 1;`.
Re-expresses fix hunk `@@ -773,7 +777,7 @@ ... -self.break_last_token = true; +self.break_last_token += 1;`
(the fix made the flag a counter so `>>=`/`<<=` broken twice is recorded as 2; the buggy
parent behaved like a bool, saturating at 1). In 1.99.1 the rest of the counter plumbing already exists
(tokenstream.rs), so only the increment is reverted. Result: a twice-broken `>>=` is rebroken only once
when the lazy token stream is made, losing the trailing tokens.
