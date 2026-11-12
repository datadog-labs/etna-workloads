# Rationale

File: src/optimizer/remove_unused_columns.cpp

1. `ExtractCastCanBePushedDown` helper and its use in `HandleExtractExpression` removed.
   Traces to both fix hunks (helper + `cast_expression = nullptr` for JSON targets on VARIANT).
   Without them a cast to JSON is attached to the extract and pushed into the shredded scan.
2. `TryGetCastChild`: removed the pre-existing `if (cast.GetReturnType().IsJSONType()) return false;`
   guard. In today's code this earlier guard independently kept JSON casts out of the pushdown,
   masking the bug (removing only 1 gave "0 of 1 oracle units fail"). Removing it lets JSON casts
   reach HandleExtractExpression, restoring the original behaviour. Side effect: it also applies to
   struct_extract JSON casts.

## Oracle
```
FAIL     test/sql/types/variant/variant_extract_json_cast_shredded.test
         test/sql/types/variant/variant_extract_json_cast_shredded.test:22
         Conversion Error: Malformed JSON at byte 0 of input: unexpected character.  Input: "x"
1 of 1 oracle units fail
```
