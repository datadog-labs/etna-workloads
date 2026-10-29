# Rationale

Fix: a comment after a DEFAULT value leaked into the default text shown by `PRAGMA table_info`.
The fix replaced the trailing `scanpt(Z)` (lookahead token start, which includes preceding whitespace/comments) with a `scantok` before the term (start+length of the first token).

Change (src/parse.y, all in the `ccons ::= DEFAULT ...` rules): reverted to the pre-fix form.
- Removed the `scantok` nonterminal (hunk 1).
- `DEFAULT scanpt(A) term(X) scanpt(Z)` -> `sqlite3AddDefaultValue(pParse,X,A,Z)`; same for the PLUS and MINUS and `DEFAULT scanpt id(X)` rules (hunk 2).
Z is the start of the lookahead token after the term, so any comment between the term and the next token is included in the stored default text.

Oracle: pragma4-5.0 fails (the table_info default for a, b, c includes the trailing comments). All other cases pass.
