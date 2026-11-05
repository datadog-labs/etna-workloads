# Rationale

PushOverrideSearchPath()/OverrideSearchPath no longer exist in REL_18_6, so the original
bug (set_config_option("search_path") ineffective under an override stack) cannot be
restored literally. The closest re-expression is within the fix's own schemacmds.c hunk.

## src/backend/commands/schemacmds.c, CreateSchemaCommand()
Traces to the fix_impl.patch hunk that builds the new search_path string from
set_config_option(). The `while (scanner_isspace(*nsp)) nsp++;` skip and the
`if (*nsp != '\0')` guard are removed; the old path is always appended as ", %s".
With a whitespace-only search_path (as the namespace test sets), the result is
"schema,  ", a trailing-comma list that is invalid GUC list syntax, so CREATE SCHEMA
fails to set search_path correctly.

## Failing oracle cases
- src/test/regress||namespace
