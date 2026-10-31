# Rationale (gh-119666)

## Change: Python/symtable.c, inline_comprehension()
The fix hoisted the "`__class__` must never be free through a class scope"
special case out of the `if (!existing)` branch so it runs whether or not the
name already exists in the class scope's symbols. I reverted that by moving the
equivalent block (in v3.15.2 it also covers `__classdict__` and
`__conditional_annotations__`, generalised from the same code) back inside
`if (!existing)`. When a prior comprehension already put `__class__` in the
class symbols, a second comprehension skips the special case, leaves
`__class__` free in the class scope and in `comp_free`, and the compiler crashes or asserts.

## Oracle failures
17 of 65 cases fail, with an incomplete run (crash/assert). They include
test_super_and_class_cell_in_sibling_comps (the fix's new test),
test_references___class___defined/_enclosing, and the related
`__classdict__`, `__conditional_annotations__` and super cases.
