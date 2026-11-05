# Rationale

## src/backend/replication/pgoutput/pgoutput.c, get_rel_sync_entry()
Traces to the single pgoutput.c hunk of fix_impl.patch (reversed in two parts):
- The unconditional `rel_publications = lappend(rel_publications, pub);` is restored before the ancestor-level check, so publications that replicate through a lower-level (child) ancestor are still tracked.
- The reset-on-higher-ancestor / same-level-Assert / track block is replaced by the old unconditional "new value is an ancestor" assignment.

Result: row filters, column lists and generated-column settings are built from publications that don't publish via the chosen ancestor, so row filters from multiple publications are combined wrongly.

## Failing oracle cases (8 of 26)
All in src/test/subscription|t/028_row_filter.pl:
- check publish_via_partition_root behavior
- check replicated rows to tab_rowfilter_2
- check replicated rows to tab_rowfilter_inherited and tab_rowfilter_child
- check replicated rows to tab_rowfilter_toast
- check replicated rows to tab_rowfilter_viaroot_part
- check replicated rows to tab_rowfilter_virtual
- check replicated rows to table tab_rowfilter_1
- check table tab_rf_partition should be filtered
