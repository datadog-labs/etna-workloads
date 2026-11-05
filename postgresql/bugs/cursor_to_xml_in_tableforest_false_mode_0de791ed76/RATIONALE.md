# Rationale

File: src/backend/utils/adt/xml.c, function `cursor_to_xml`.

Two hunks, both from fix.patch's `cursor_to_xml` hunks:
1. Removed the `if (!tableforest)` block that calls `xmldata_root_element_start(&result, "table", NULL, targetns, true)` and appends a newline, before `SPI_connect()`.
2. Removed the `if (!tableforest) xmldata_root_element_end(&result, "table");` call before `PG_RETURN_XML_P`.

The forward declarations from fix.patch were left in place. They are harmless, and the functions are defined later in the file.

With these removed, `cursor_to_xml(..., tableforest => false)` emits bare row elements with no enclosing `<table>` root element. That is the original bug.

Failing oracle case: src/test/regress||xmlmap
