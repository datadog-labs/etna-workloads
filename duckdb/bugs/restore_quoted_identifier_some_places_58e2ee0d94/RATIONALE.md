# Rationale
Hunks (grammar sources under src/src/parser/peg/grammar/statements, plus regenerated src/src/include/duckdb/parser/peg/inlined_grammar.hpp via scripts/parser/inline_grammar.py):
- execute.gram `ExecuteStatement`: ColIdOrString -> Identifier (fix hunk `ExecuteStatement`).
- prepare.gram `PrepareStatement`: ColIdOrString -> Identifier (fix hunk `PrepareStatement`).
- deallocate.gram `DeallocateStatement`: ColIdOrString -> Identifier (fix hunk `DeallocateStatement`).
Single-quoted names are rejected again by the PEG parser, so `PREPARE 'p' AS SELECT 42;` in single_quoted_names.test fails with a parser error.
Only a subset of the fix's hunks is reverted (minimal); other rules left as-is.
Oracle result: see etna-check output below.

etna-check output:
FAIL     test/sql/parser/single_quoted_names.test
         Query unexpectedly failed! (test/sql/parser/single_quoted_names.test:6)!
         PREPARE 'p' AS SELECT 42;
         Parser Error: syntax error at or near "'p'"
1 of 1 oracle units fail
