# Rationale

Fix: legacy schemas may have `CONSTRAINT name` *after* a column/table constraint; the
pre-fix grammar only allowed it *before* (`cname ccons` / `cname tcons`), so such schemas
failed to parse. In 3.54.1 the trailing form is accepted because `CONSTRAINT nm` is a
standalone `ccons` / `tcons` item. All changes are in src/parse.y.

- Column hunk (`carglist ::= carglist cname ccons` + cname rules): restored the pre-fix
  `carglist ::= carglist cname ccons.` with `cname ::= CONSTRAINT nm` / `cname ::= .`
  (empty form resets constraintName, as before), and removed `ccons ::= CONSTRAINT nm`.
  CONSTRAINT can now only precede a constraint.
- Table hunk (`conslist ::= conslist COMMA cname tcons`, `conslist ::= cname tcons`):
  restored these, replacing `tconscomma` and `tcons ::= CONSTRAINT nm`. The empty cname
  rule also does the reset the old `tconscomma ::= COMMA` action did.
- The `columnid` reset hunk isn't needed: 3.54.1 resets via the empty `cname` / sqlite3AddColumn paths.

Oracle failures: check-2.10 (syntax error on trailing `CONSTRAINT one`/`constraint two`/
`constraint three`), and consequently check-2.11, 2.12, 2.13 (table not created).
