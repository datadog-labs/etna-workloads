# Rationale

Changed: src/backend/utils/adt/xml.c, `xml_xmlnodetoxmltype()`.

Traces to the fix.patch hunk in `xml_xmlnodetoxmltype` that added `xmlCopyNode(cur, 1)` before `xmlNodeDump`. The fix dumps a copy, because the copy carries the namespace definitions inherited from ancestors. In current code that is the `cur_copy = xmlCopyNode(...)` / `nodefree` block. I removed it and made `xmlNodeDump` dump `cur` directly. `nodefree` stays NULL, so nothing is freed.

This brings the bug back: xpath() results for element nodes no longer include namespace declarations from ancestors.

Oracle case expected to fail: src/test/regress||xml
