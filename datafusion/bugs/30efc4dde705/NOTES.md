Reproducer: `SELECT NULL + NULL, NULL - NULL, NULL * NULL, NULL / NULL, NULL % NULL;`
(from the operator.slt record added by the fix).
Clean build returns a row of NULLs; the buggy build fails at planning because
NULL op NULL arithmetic has no coercion signature.
