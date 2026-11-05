# Rationale

## Changed hunk
- File: src/interfaces/ecpg/preproc/ecpg.trailer, rule `connect_options` (second alternative).
- Traces to the ecpg.trailer hunk of fix_impl.patch (`cat_str(3, ...)` replaced by `make3_str(...)`).
- Reverted to `cat_str(3, make2_str(@1, @2), @3, @4)`. `cat_str` inserts spaces between its arguments, so the preprocessor again emits whitespace around '&' in connection URL options.
- The ecpglib/connect.c hunk of the fix only changed a comment, so nothing was changed there.

## Failing oracle cases
- src/interfaces/ecpg||connect/test5
