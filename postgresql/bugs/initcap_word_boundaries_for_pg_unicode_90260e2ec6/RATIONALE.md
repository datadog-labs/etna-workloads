# Rationale
- File/function: src/backend/utils/adt/pg_locale_builtin.c, initcap_wbnext(). Traces to the fix_impl.patch hunk changing `pg_u_isalnum(u, true)` to `pg_u_isalnum(u, wbstate->posix)`.
- Restored the bug: the call hardcodes posix=true, so PG_UNICODE_FAST (full case mapping) uses POSIX alnum semantics for INITCAP word boundaries (e.g. U+FF11 is not treated as alphanumeric). The `posix` struct field is left in place but unused.

Failing oracle case: src/test/regress||collate.utf8
