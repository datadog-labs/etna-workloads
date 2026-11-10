# Bug
console.table measured cell width by counting UTF-16 code units (after stripping colors and NFC-normalizing) instead of display width, so full-width/CJK characters misalign table columns.

# Change (lib/internal/cli_table.js)
- Hunk 1 (import): replaced the `getStringWidth` import with `removeColors` and re-added `countSymbols` (the fix removed it); uses `.normalize('NFC').length` (equivalent to the old UCS-2 byte length / 2).
- Hunks 2-4 (renderRow, head widths, cell widths): `getStringWidth(...)` calls replaced by `countSymbols(...)`, as before the fix.

# Failing test
parallel/test-console-table fails:
```
+   "│ foo     │ '￥'    │",
-   "│ foo     │ '￥'   │",
```
