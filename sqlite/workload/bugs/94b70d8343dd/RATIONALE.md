# Rationale

Fix hunk (src/pragma.c): integrity_check type-checked ANY columns of STRICT tables
(`if TF_Strict` became `TF_Strict && eCType!=COLTYPE_ANY`).

In 3.54.1 the code is restructured: `doTypeCheck = pCol->eCType>COLTYPE_ANY` for strict
tables, and the per-type mask table `aStdTypeMask[]` has ANY = 0x1f (accept anything).
Two edits in src/pragma.c (integrity_check) restore the old behaviour:
1. `doTypeCheck = pCol->eCType>=COLTYPE_ANY` - ANY columns are type-checked again
   (reverses the `pCol->eCType!=COLTYPE_ANY` exclusion).
2. `aStdTypeMask[ANY]` 0x1f -> 0x10 (NULL only), so the check on ANY actually
   enforces a type as the pre-fix code did, instead of being a no-op that the newer mask covers.

Oracle failures: strict2-2.0 (integrity_check on `t2(a INT, b ANY) STRICT` reports
"non-ANY value in t2.b" instead of ok) and strict2-3.0 (spurious extra errors for the ANY id column).
