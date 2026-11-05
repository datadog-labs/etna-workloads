# Rationale

File: src/backend/utils/adt/ri_triggers.c, function ri_KeysEqual (PK branch).
Traces to the fix.patch hunk in ri_KeysEqual that made the PK side use datum_image_eq (bytewise) instead of the equality operator.
Reverted: for rel_is_pk the comparison now uses pp_eq_oprs via ri_CompareWithCast, so a PK update to a value that is equal under the operator but byte-different (e.g. numeric 1.0 -> 1.00, or case-insensitive/nondeterministic collations) is treated as "unchanged". The RI update trigger is skipped, so ON UPDATE CASCADE does not propagate the change to referencing rows.
(datum_image_eq itself is left in place; it is still used by record_image_eq.)

Failing oracle case: src/test/regress||foreign_key
