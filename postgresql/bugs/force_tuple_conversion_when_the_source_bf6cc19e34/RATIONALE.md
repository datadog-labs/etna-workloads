# Rationale

Hunk: src/backend/access/common/attmap.c, `check_attrmap_match()`.
Traces to the fix.patch hunk that added the `inatt->atthasmissing` check (returns false to force a conversion).
I removed that check. With an identity attribute map and a source that has missing (fast-default) attributes, no tuple conversion happens, so the missing-attribute values are lost.

Oracle case expected to fail: src/test/regress||alter_table
