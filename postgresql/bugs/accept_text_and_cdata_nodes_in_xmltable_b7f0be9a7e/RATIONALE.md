# Rationale

## src/backend/utils/adt/xml.c, XmlTableGetValue (single-node, non-XML column branch)
Traces to the fix.patch hunk that added the `node` variable and the XML_TEXT_NODE / XML_CDATA_SECTION_NODE
exception before xmlNodeListGetString. The current code uses xmlXPathCastNodeSetToString there. I changed it back to
`xmlNodeListGetString(doc, nodeTab[0]->xmlChildrenNode, 1)`, with no special case for text and CDATA nodes. Those
nodes have no children, so the result is NULL and the column becomes "" instead of the node's content. This
happens for column expressions such as `text()`.

## Failing oracle cases
src/test/regress||xml
