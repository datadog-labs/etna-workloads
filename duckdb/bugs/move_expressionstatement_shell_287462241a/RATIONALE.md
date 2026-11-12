# move_expressionstatement_shell_287462241a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 287462241aacf660f0140cb20324132f86d5b954 ("Move the expressionstatement to the shell"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_grammar_extension.cpp::Parser options retain their compiled grammar
- test/sql/pragma/test_pragma_parsing.test
- test/sql/transactions/test_parser_error_transaction_invalidation.test
