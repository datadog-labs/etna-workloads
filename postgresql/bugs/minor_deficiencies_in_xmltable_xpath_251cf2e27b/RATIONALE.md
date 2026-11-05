# Rationale

All changes are in `src/backend/utils/adt/xml.c`.

1. `xml_xmlnodetoxmltype()` — traces to the fix.patch hunk that changes
   `if (cur->type == XML_ELEMENT_NODE)` to
   `if (cur->type != XML_ATTRIBUTE_NODE && cur->type != XML_TEXT_NODE)`.
   I restored the old `== XML_ELEMENT_NODE` test. Only elements are now dumped
   as a subtree. Other node types (comments, PIs, CDATA, documents) go through
   the string-cast path, so xpath() and XMLTABLE return them wrongly.

2. `XmlTableGetValue()`, `XPATH_STRING` branch — traces to the fix.patch hunk
   that added escaping for XML-typed columns
   (`if (typid == XMLOID) cstr = escape_xml(...)`).
   I removed the escaping, so an XPath string result such as `a<b` in an XML
   column is returned unescaped.

Failing oracle case (confirmed by running the oracle): `src/test/regress||xml`.
