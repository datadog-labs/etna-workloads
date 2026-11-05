# Rationale

## Changed hunk
- File: src/backend/utils/adt/pgstatfuncs.c, function pg_stat_get_activity
- Traces to the single hunk of fix_impl.patch (pgstatfuncs.c).
- The fix made clientdn NULL when ssl_client_dn is empty. The column is now values[22] (was values[23]). I removed the `if (...[0]) ... else nulls[22] = true;` and always call CStringGetTextDatum(ssl_client_dn). Connections without a client certificate now show an empty string in pg_stat_ssl.client_dn instead of NULL.

## Failing oracle case
- src/test/ssl|t/001_ssltests.pl|pg_stat_ssl view without client certificate: matches
