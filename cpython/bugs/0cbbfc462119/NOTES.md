Reproducer: feeds `<svg><text y="100"><![CDATA[a]] >b]]></text></svg>` to an HTMLParser with CDATA support enabled (`_support_cdata = True`) and prints the events.

Clean: one `unknown decl 'CDATA[a]] >b'`, as the HTML spec requires (CDATA ends only at a literal `]]>`).
Buggy: parse_marked_section is used, which accepts `]] >` as a terminator. The output becomes `unknown decl 'CDATA[a'` followed by `data 'b]]>'`.
