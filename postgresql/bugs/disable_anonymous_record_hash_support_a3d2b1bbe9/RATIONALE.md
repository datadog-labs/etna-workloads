# Rationale

Changed hunk: `src/backend/utils/cache/typcache.c`, `cache_record_field_properties()`.
Traces to the typcache.c hunk of fix.patch. The fix stopped setting
TCFLAGS_HAVE_FIELD_HASHING and TCFLAGS_HAVE_FIELD_EXTENDED_HASHING for RECORDOID.
I put those flags back (and the old comment), so the type cache again claims
anonymous record is hashable. The planner then picks hash-based plans for
UNION/INTERSECT/EXCEPT, and so on, over record columns. Those plans fail at
execution when a record component has no hash support.

I did not re-add the other parts of the fix (the require_hash parameter and
the hash_array special case). They are only needed once record hashing is off,
so they are harmless here.

Failing oracle case: src/test/regress||union
