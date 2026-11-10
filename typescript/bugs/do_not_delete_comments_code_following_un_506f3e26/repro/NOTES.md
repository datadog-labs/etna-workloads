Unterminated string literal `a["foo.b // some comment!!` with completions requested mid-string (after `foo.b`).
Clean: completion replacementSpan stops at the cursor (`foo.b`). Injected: span extends to end of the line, swallowing ` // some comment!!`.
