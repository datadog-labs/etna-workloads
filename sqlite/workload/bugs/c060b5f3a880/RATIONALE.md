# Rationale

Fix: in JSON5 text, a `"` inside a single-quoted string must be escaped as `\"` when rendered as canonical JSON.

Changed (src/json.c, `jsonTranslateBlobToText`, `case JSONB_TEXT5`). In 3.54.1 the fix's logic lives here instead of `jsonAppendNormalizedString`:
- The scan loop again treats `"` as an ordinary character, as the pre-fix loop (which only stopped at `\\`) did. This reverses the fix's `&& zIn[i]!='"'` loop-condition hunk.
- The `if( zIn[0]=='"' ){ append "\\\"" ... continue; }` block is removed, reversing the fix's added block.

Result: `"` is copied through unescaped, producing invalid JSON.

Oracle: `json501-13.1` fails. `SELECT json('{x:''a "b" c''}')` returns `{"x":"a "b" c"}` instead of `{"x":"a \"b\" c"}`.
