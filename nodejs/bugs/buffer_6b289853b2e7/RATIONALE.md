# Blob.slice regression

Bug: `Blob.prototype.slice` used to be non-spec-compliant: out-of-range or inverted `end` threw `ERR_OUT_OF_RANGE` instead of being clamped, and the default content type inherited the source blob's type instead of `''`.

Changes (lib/internal/blob.js), corresponding to the fix's `slice` hunk:
- Replaced the clamping of `start`/`end` (MathMax/MathMin) with the old `end<0` offset plus throws of `ERR_OUT_OF_RANGE` when `end < start` or `end > size` (old validation logic); added `ERR_OUT_OF_RANGE` import (fix removed it).
- Default `contentType` parameter is `this[kType]` again instead of `''`.

Failing test: parallel/test-blob (e.g. `blob.slice(-1, 1)` / `slice(1, 100)` now throw ERR_OUT_OF_RANGE, and `f.slice(1,-1).type` is 'foo' instead of '').
