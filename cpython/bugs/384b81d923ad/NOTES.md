Parses an XML doc with a lone CDATA child in `<node>` and prints `toprettyxml()`.
Clean: `<node><![CDATA[</data>]]></node>` stays inline. Buggy: CDATA is treated
as a non-text single child, so newlines/indent are injected inside `<node>`
(which changes the text content on reparse).
