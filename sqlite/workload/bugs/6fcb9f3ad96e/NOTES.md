repro.sql builds an fts3 table and calls snippet() on a MATCH query with more than 64 phrases (fts3snippet-5.1).
Clean shell: prints the three snippets. Buggy shell: the changed assert `i<=64` in fts3SnippetDetails fails (and `1<<i` is undefined for i>=64), so it aborts.
