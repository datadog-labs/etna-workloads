# Rationale

## src/src/backend/parser/parse_coerce.c, enforce_generic_type_consistency()
Traces to the fix.patch hunk that removed `Assert(!IsPolymorphicType(rettype));` from the
"Fast Track" branch (no polymorphic arguments). I restored the Assert and the old comment.
Some built-in functions (e.g. array_in(), which returns a polymorphic type from non-polymorphic
args) legitimately reach this path, so the Assert fires in assert-enabled builds.

Failing oracle case: src/test/regress||polymorphism
