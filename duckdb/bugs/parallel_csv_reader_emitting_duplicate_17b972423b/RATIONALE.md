# Re-introduced bug: parallel CSV reader duplicates rows with \r\r\n

File/function: src/execution/operator/csv_scanner/scanner/string_value_scanner.cpp, `StringValueScanner::ProcessOverBufferValue()`

Hunks (both trace to the single hunk set of fix 17b9724):
1. Removed `idx_t pre_carry_pos = iterator.pos.buffer_pos;` before the CARRY_ON newline-consuming loop (fix added it).
2. Removed the early `return` after that loop (condition: over_buffer_string empty, chars consumed, last_position past the buffer, first consumed char is '\r'). Without it, when a buffer boundary falls between the two '\r' of "\r\r\n", the row was already counted by the previous buffer but this scanner falls through and processes the next row too, so it is counted twice.

Oracle: test/sql/copy/csv/parallel/test_rrrn_parallel.test is expected to fail (duplicate/extra rows in parallel mode). See etna-check output below.

## etna-check result
```
build ok; running oracle tests ...
FAIL     test/sql/copy/csv/parallel/test_rrrn_parallel.test
         test/sql/copy/csv/parallel/test_rrrn_parallel.test:34 ::  1. ...
         Wrong result in query! (test/sql/copy/csv/parallel/test_rrrn_parallel.test:34)!
1 of 1 oracle units fail
```
The parallel-vs-sequential row count query returns a wrong result (duplicated rows in parallel mode).
