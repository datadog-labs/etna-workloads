repro.sql runs `DETACH x IS #1;`, which is a syntax error. The `#1` token is a bad variable reference.

- Clean shell: prints `near "#1": syntax error` and exits with status 1.
- Buggy shell: codeAttach() no longer checks `pParse->nErr`, so it generates code anyway. That hits `assert(0)` in resolveExprStep and aborts (-6).
