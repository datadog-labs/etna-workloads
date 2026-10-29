# Rationale

Fix: OP_TypeCheck (COLTYPE_REAL) rejected a MEM_IntReal value because it only accepted MEM_Real. A generated column on a STRICT table copying a REAL value that had become IntReal raised a spurious datatype error.

Changes in tree/src/vdbe.c:

1. OP_TypeCheck, COLTYPE_REAL: `else if( (pIn1->flags & (MEM_Real|MEM_IntReal))==0 )` reverted to `(pIn1->flags & MEM_Real)==0`. This reverses the fix hunk directly.
2. applyAffinity(): `(pRec->flags & (MEM_Real|MEM_IntReal))==0` reverted to `(pRec->flags & MEM_Real)==0`. In 3.54.1 this second path also covers the case. It turns an IntReal into MEM_Int before the type check when affinity is REAL, so reversing only hunk 1 does not trigger the bug. The pre-fix applyAffinity ignored IntReal, which is what this restores. It is the same defect, since IntReal is not recognised as REAL.

Oracle: strict1-8.1 (and the following cases) now abort with
`Assertion '(pIn1->flags & MEM_IntReal)==0' failed` in OP_TypeCheck. Without the assert, it would report a "cannot store ... in column" type error instead of the expected `{} 250.0 250.0`. The IntReal value reaches OP_TypeCheck when the generated column is computed.
