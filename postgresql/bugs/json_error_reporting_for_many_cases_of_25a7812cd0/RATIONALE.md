# Rationale
File: src/common/jsonapi.c, function json_lex_string (hunks trace to the jsonapi.c hunks of fix.patch).
Changed the FAIL_AT_CHAR_END(...) exits for JSON_UNICODE_HIGH_SURROGATE, JSON_UNICODE_LOW_SURROGATE (several sites),
JSON_UNICODE_CODE_POINT_ZERO and JSON_UNICODE_UNTRANSLATABLE back to bare `return CODE;`, and removed the
`lex->token_terminator = s + 1` on the trailing-high-surrogate exit. These error exits no longer advance
token_terminator past the offending character, so error context is computed from a stale terminator (wrong/empty context).
Failing oracle case: src/test/regress||json_encoding
