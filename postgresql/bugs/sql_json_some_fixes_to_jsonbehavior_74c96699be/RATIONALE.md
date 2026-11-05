# Rationale

File: src/backend/parser/parse_expr.c, function transformJsonBehavior().

Traces to the single fix.patch hunk in transformJsonBehavior. The block that
decides how to coerce a JsonBehavior expression is reverted to its pre-fix form:

- Runtime coercion via json_populate_type() applies only to NULL consts and
  jsonb expressions of the *implicit* default behavior (`btype == default_behavior`).
  A user-specified jsonb DEFAULT is no longer coerced at runtime.
- The boolean-to-jsonb Const rewrite (TRUE/FALSE ON ERROR with non-int returning) is removed.
- The `exprType != returning->typid` guard is removed, along with the
  typcategory-based ASSIGNMENT cast. The old baseTypmod / text-cast logic and
  COERCE_IMPLICIT_CAST are restored.
- The DEFAULT-specific errhint is removed.

Together these bring back the wrong coercion of JsonBehavior expressions.

Oracle cases that fail (confirmed by agent_oracle.py): src/test/regress||sqljson_jsontable and
src/test/regress||sqljson_queryfuncs.
