# Rationale
- File/function: src/backend/optimizer/util/clauses.c, eval_const_expressions_mutator (case T_NullTest).
- Traces to the fix.patch hunk that replaces `newntest->argisrow = type_is_rowtype(exprType(relem))` with `argisrow = false` (and adds the explanatory comment). Reversed: per-field NullTests again inherit argisrow from the field's type, and the comment is removed.
- Why it is a bug: a composite-typed field inside ROW(...) IS [NOT] NULL gets a recursive (row-semantics) null test instead of a scalar attisnull-style test, so the constant-folded result differs from the executor's non-recursive semantics.
- The other two hunks in fix_impl.patch (the `ntest->argisrow &&` check and the Assert) are already equivalent in the current code and were left alone. The execQual.c hunk only adds a comment.

Failing oracle case: src/test/regress||rowtypes
