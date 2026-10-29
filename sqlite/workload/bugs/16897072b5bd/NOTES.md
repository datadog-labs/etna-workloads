Reproducer: a nocase-indexed TEXT column holding both text and blob values, queried with `x LIKE 'ab%' ORDER BY x DESC` (like3-3.1).
The LIKE optimization scans the range twice (text, then blob). With the bug, the DESC scan's repeat-counter logic is wrong, so the result rows differ from the clean shell. Clean returns the blobs first, then the text, in descending order.
