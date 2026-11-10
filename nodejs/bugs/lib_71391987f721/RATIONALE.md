# MIME overmatch in data URLs

**Bug:** the regex in `mimeToFormat` (now `lib/internal/modules/esm/get_format.js`) lacked `^`/`$` anchors, so any MIME string merely *containing* `text/javascript` (e.g. `WRONGtext/javascriptFORMAT`) was treated as a JS module instead of throwing ERR_UNKNOWN_MODULE_FORMAT.

**Hunk:** get_format.js line 43: `/^\s*(text|application)\/javascript\s*(;\s*charset=utf-?8\s*)?$/i` -> `/\s*(text|application)\/javascript\s*(;\s*charset=utf-?8\s*)?/i`. This corresponds to the fix's single implementation hunk in formats.js (file has since moved), removing the anchors.

**Failing test:** es-module/test-esm-invalid-data-urls (`not ok`, stable across 2 runs): importing `data:WRONGtext/javascriptFORMAT,...` no longer rejects with ERR_UNKNOWN_MODULE_FORMAT.
