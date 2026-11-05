# Rationale

## Hunk: src/pl/plpython/plpy_typeio.c, PLyUnicode_ToComposite()
Traces to the fix.patch hunk in PLyString_ToComposite (now PLyUnicode_ToComposite). The fix made the
string-to-composite path pass the real typmod (`desc->tdtypmod` instead of the unblessed
`info->out.d.typmod`) to the input function. Code has since been refactored; the equivalent is the
typmod passed to InputFunctionCall (record_in), `arg->typmod`, which PLy_output_setup_record sets from the blessed descriptor.
I changed it to a constant -1. For a RECORD result returned as a string, record_in is then given
typmod -1 (anonymous record) instead of the blessed typmod, so it fails or misbehaves.

## Failing oracle cases
- src/pl/plpython||plpython_composite
