# Rationale

v3.15.2 already contains the whole fix (excs_str field, saved repr in `BaseExceptionGroup_new`, `BaseExceptionGroup_repr`).

## Change (Objects/exceptions.c)
In the `ComplexExtendsException(... BaseExceptionGroup ...)` definition, the EXCREPR slot is set back to `0`
instead of `BaseExceptionGroup_repr`. This reverses the fix hunk that added the `EXCREPR` argument/`tp_repr`
slot and wired `BaseExceptionGroup_repr`. With no tp_repr, the type inherits `BaseException_repr`, which
formats from `self->args` as before the fix, so the repr follows later mutation of the original sequence
(and the exceptions string saved in `excs_str` is never used).

## Oracle failures
test_exception_group.StrAndReprTests (e.g. test_repr_small_size_args: `ExceptionGroup()` instead of
`ExceptionGroup('msg', (ValueError(),))`) and the repr/mutation test; 2 failures total.
