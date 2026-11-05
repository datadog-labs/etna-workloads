# Rationale

File: src/backend/optimizer/path/costsize.c, function get_foreign_key_join_selectivity.
Traces to the costsize.c hunks of fix_impl.patch (reversed):

1. The "all clauses found" check is back to
   `list_length(removedlist) != nmatched_ec + nmatched_ri`. The fix added
   `removedlist == NIL ||` and subtracted `nconst_ec`. Without the subtraction,
   an FK matched through an ec_has_const EC (which generates no join clauses)
   never reaches the expected count, so the FK is ignored.
2. Removed the block that divides fkselec by the selectivity of the derived
   "var = const" restriction on the referencing Var, so the constant's
   selectivity is double-counted. Also removed the final CLAMP_PROBABILITY(fkselec).

The nconst_ec and fk_eclass_member fields and ec_derives bookkeeping are left in place.
That is harmless, and the bug lives in the estimation logic.

Failing oracle case: src/test/regress||join (plan or estimate changes in the FK-with-constants tests).
