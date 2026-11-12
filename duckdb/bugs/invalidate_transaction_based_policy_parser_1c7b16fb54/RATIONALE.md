# Rationale

Hunk 1: src/src/main/client_context.cpp, the `peek_or_error` lambda in the multi-statement `Query` path.
Traces to the fix's hunk in `ClientContext::Query`, which made the parser-error catch block invalidate the transaction per policy.
In today's code that catch returned `ErrorResult<QueryResult>(...)`, which does the invalidation. I replaced it with `ProcessError` plus a bare `QueryResult`, so a parse error no longer invalidates the active transaction. This was the behaviour before the fix.

The second hunk of the fix, the setting-message typo, is cosmetic. I did not revert it.

## Oracle
```
FAIL     test/sql/transactions/test_parser_error_transaction_invalidation.test
         ...test:22 :: Query unexpectedly succeeded!
         insert into audit values (22);
1 of 1 oracle units fail
```
