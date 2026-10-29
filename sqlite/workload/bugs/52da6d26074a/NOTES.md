Reproducer (repro.sql): parses JSON5 numbers with a sign and a leading decimal point
(`-.5`, `+.5`, `-.5e-1`, `+.5e-2`), as in json501-8.4/8.5/8.10/8.11.
Clean shell returns -0.5, 0.5, -0.05, 0.005. The buggy shell fails each statement with
"malformed JSON" and exits with status 1.
