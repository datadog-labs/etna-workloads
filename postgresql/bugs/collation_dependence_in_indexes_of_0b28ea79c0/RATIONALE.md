# Rationale

Hunk: src/backend/catalog/genbki.pl, line ~961 (attcollation assignment for collation-aware catalog columns).

Traces to fix_impl.patch hunks in indexing.h (seclabel/shseclabel/replication_origin indexes on text columns).
The original fix made those indexes collation-independent (text_pattern_ops). In REL_18 the same guarantee comes
from catalog text columns using the "C" collation, so the index declarations (`text_ops`) are safe. Setting
attcollation to the default collation (OID 100) instead of C makes those indexes (and other catalog text
indexes) collation-dependent again.

Failing oracle case: src/test/regress||opr_sanity
