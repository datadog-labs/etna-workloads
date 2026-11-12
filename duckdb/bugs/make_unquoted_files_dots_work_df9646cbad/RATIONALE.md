# Rationale

Reverted the fix's reordering of the `CopyFileName` PEG rule (alternatives swapped back to
`... / CopyFileNameIdentifier / CopyFileNameIdentifierColId`), so `Identifier` matches first and
stops at the dot in unquoted dotted file names (e.g. `parity.csv`).

Hunks (all trace 1:1 to the fix's hunks):
- src/parser/peg/grammar/statements/copy.gram: `CopyFileName` rule order.
- src/include/duckdb/parser/peg/inlined_grammar.gram: same rule.
- src/include/duckdb/parser/peg/inlined_grammar.hpp: byte array of the inlined grammar, regenerated with the same swap.

Oracle: test/sql/peg_parser/parser/copy_file_name.test — results appended below.

## etna-check output
FAIL     test/sql/peg_parser/parser/copy_file_name.test
         Query unexpectedly failed! (test/sql/peg_parser/parser/copy_file_name.test:17)!
         EXPLAIN COPY copy_file_name TO parity.csv (FORMAT CSV);
         Parser Error: syntax error at or near "."
1 of 1 oracle units fail
