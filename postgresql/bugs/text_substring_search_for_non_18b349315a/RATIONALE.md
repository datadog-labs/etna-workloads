# Rationale

File: src/backend/utils/adt/varlena.c, function text_position_next_internal (single hunk set, tracing to the one fix.patch hunk set in the same function).

- Removed `Assert(needle_len > 0)`.
- Nondeterministic-collation loop: replaced the `do { test_end += pg_mblen(); ... } while (test_end < haystack_end)` (which only tests non-empty substrings) with the original `for (test_end = hptr; test_end < haystack_end; test_end += mblen)`, which first tests the empty substring (test_end == hptr). A collation that treats an empty string as equal to the needle then yields an empty match, so callers searching for successive matches (replace, split_part, etc.) get wrong results / loop.
- Comment and `const char *test_end` declaration reverted accordingly.

Failing oracle case: src/test/regress||collate.icu.utf8
