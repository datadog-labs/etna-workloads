# Rationale

## Changed hunk
File: src/src/backend/optimizer/util/tlist.c, function split_pathtarget_walker().

Traces to the fix.patch hunk in tlist.c that introduced the nesting-depth logic
("each SRF must be computed at a level corresponding to the nesting depth of SRFs
within its arguments"). In today's code that logic is the line
`srf_depth = context->current_depth + 1;` ("Depth is one more than any SRF below it").
The bug version is `srf_depth = 1;`.

Why it brings the bug back: the pre-fix code did not assign nested SRFs to levels by
depth. Every SRF was treated as if it sat at a single level. With `srf_depth = 1`,
`srf1(x), srf2(srf3(y))` puts srf3 and srf2 at the same level, so tSRFs at different
nesting levels are mishandled.

## Failing oracle cases
- src/test/regress||tsrf

subselect still passes.
