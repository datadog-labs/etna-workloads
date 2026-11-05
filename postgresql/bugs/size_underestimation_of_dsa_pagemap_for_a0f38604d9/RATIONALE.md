# Rationale

File: src/backend/utils/mmgr/dsa.c, function make_new_segment(), odd-sized segment branch (`requested_pages > usable_pages`).

Changed hunk: removed the block that does
`metadata_bytes += ceil(metadata_bytes / (FPM_PAGE_SIZE - sizeof(dsa_pointer))) * sizeof(dsa_pointer);`
This is the second hunk of fix.patch (the pagemap-size correction). Without it the pagemap is sized only for `usable_pages` entries, but it is indexed by every page in the segment, metadata pages included. So the pagemap is underestimated for odd-sized segments.

The fix's `total_requested_pages` variable and the Assert that checks pagemap capacity are left in place. They are the only thing that detects the underestimate in an assert-enabled build. I first removed them as well, and the oracle test passed, so I restored them.

Oracle cases that fail: src/test/modules/test_dsa||test_dsa (the Assert fires in test_dsa_allocate).
