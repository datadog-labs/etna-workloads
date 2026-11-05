# Rationale

## src/backend/parser/parse_func.c, LookupFuncWithArgs() (FUNCLOOKUP_AMBIGUOUS case)
Traces to the fix.patch hunk that rewrote LookupFuncWithArgs/LookupFuncName so that
`missing_ok` suppresses only "no such function" errors, while ambiguity errors are
raised regardless ("If nargs == -1 and multiple functions are found ... we will raise an
ambiguous-function error, regardless of what missing_ok is set to").
Before the fix, `noError` suppressed the ambiguity error too (DROP ... IF EXISTS on an
ambiguous name silently did nothing). I re-added that: in the FUNCLOOKUP_AMBIGUOUS case,
`if (missing_ok) break;` skips the error, so the function returns InvalidOid silently.

## Failing oracle case
- src/test/regress||drop_if_exists (DROP FUNCTION/PROCEDURE/ROUTINE IF EXISTS on an ambiguous name no longer errors)
