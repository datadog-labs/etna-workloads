# Rationale

All changes are in `src/interfaces/ecpg/preproc/type.c`. Each one reverses a hunk of fix_impl.patch.

1. `ECPGdump_a_type`, `ECPGt_array` case. This traces to hunk 1 of fix_impl.patch. The call to `ECPGdump_a_simple` again passes `NULL` as the structure size instead of `struct_sizeof`. As a result, arrays of structure members lose the stride to the next element.
2. `ECPGdump_a_simple`, the `arrsize < 0` check. This traces to hunk 2 of fix_impl.patch. The `&& !size` condition is removed, so `arrsize` is always forced to 1 when it is negative. That also clobbers the -1 used for members addressed through a pointer to a structure.
3. `ECPGdump_a_simple`, the offset selection. This traces to hunk 2 of fix_impl.patch. The condition once again includes `strcmp(arrsize,"0")==0 || strcmp(arrsize,"1")==0`. Because of that, the structure size is ignored when `arrsize` is 0 or 1 and `sizeof(type)` is used instead.

Failing oracle cases (all 5):
- preproc/array_of_struct
- preproc/outofscope
- preproc/pointer_to_struct
- preproc/type
- preproc/variable
