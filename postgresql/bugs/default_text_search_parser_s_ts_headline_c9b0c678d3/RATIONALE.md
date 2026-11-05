# Rationale

All changes are in `src/backend/tsearch/wparser_def.c`. `hlCover` was rewritten later, so the hlCover hunks are not reverted. The hunks below are the ones that still apply.

1. `BADENDPOINT` macro: this traces to the first fix hunk. I removed the `&& !INTERESTINGWORD(j)` clause. Query words that are short or of a no-end token type are again treated as bad endpoints.
2. `mark_hl_words`, shortening loop: this traces to the hunk that moved the `BADENDPOINT` check to the top of the loop. The old order is restored. `pose = i` is assigned before the check, and the loop trims at least one word.
3. `mark_hl_words`, headline adoption: this traces to the hunk that added `poscover` and `bestcover`. The old condition is restored: adopt the first headline, or one with more interesting words and a good endpoint, or one that replaces a bad endpoint. Whether the headline includes the original cover is no longer considered. As a result, phrase-query headlines can drop part of the matching phrase.

Failing oracle case (confirmed): `src/test/regress||tsearch`.
